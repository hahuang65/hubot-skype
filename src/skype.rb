#!/usr/bin/ruby

require 'rubygems'
require 'skypekit'
require 'json'
require 'redis'

$redis = Redis.new
$redis

$skype = Skypekit::Skype.new(:keyfile => './keypair.pem')

$skype.start
$skype.login(skype_username, skype_password)

def terminate
  puts "Terminating"
  $skype.stop
  exit
end

trap('INT') do
  terminate
end

def to_hubot(chatter)
  user = chatter.author_displayname
  room = chatter.convo_id
  message = chatter.body

  json_string = {
    'user' => user,
    'room' => room,
    'message' => message
  }.to_json

  $redis.lpush('inbox', json_string)
  $redis.publish('mailman', "incoming message")
end

loop do
  event = $skype.get_event

  if event
    case event.type
    when :account_status

      if event.data.logged_in?
        puts "Congrats! We are Logged in!"
      end

      if event.data.logged_out?
        puts "Authentication failed: #{event.data.reason}"
        terminate
      end

    when :chat_message
      chatter = event.data

      to_hubot(chatter)
    end
  end

  payload = $redis.lpop('outbox')
  if payload
    chat_message = JSON.parse(payload)

    $skype.send_chat_message(chat_message['room'], chat_message['message'])
  end
end
