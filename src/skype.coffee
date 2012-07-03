Robot   = require("hubot").robot()
Adapter = require("hubot").adapter()

Redis = require("redis");
Lister = Redis.createClient();
Pubsub = Redis.createClient();
Pubsub.subscribe('mailman');

class SkypeAdapter extends Adapter
  send: (user, strings...) ->
    out = ""
    out = ("#{str}\n" for str in strings)
    json = JSON.stringify
      room: user.room
      message: out.join('')

    Lister.lpush('outbox', json)

  reply: (user, strings...) ->
    @send user, strings...

  run: ->
    self = @

    @skype = require('child_process').spawn(./skype.rb')
    @skype.stderr.on 'data', (data) =>
      console.log "ERR #{data.toString()}"
    @skype.on 'exit', (code) =>
      console.log('child process exited with code ' + code)
      Pubsub.quit
      Lister.quit
    @skype.on "uncaughtException", (err) =>
      @robot.logger.error "#{err}"

    Pubsub.subscribe('mailman')

    process.on "uncaughtException", (err) =>
      @robot.logger.error "#{err}"

    @emit "connected"

    Pubsub.on 'message', (channel, data) =>
      Lister.lpop 'inbox', (err, data) =>
        decoded = JSON.parse(data.toString())
        user = self.userForName decoded.user
        unless user?
          id = (new Date().getTime() / 1000).toString().replace('.','')
          user = self.userForId id
          user.name = decoded.user
        user.room = decoded.room
        return unless decoded.message
        message = new Robot.TextMessage user, decoded.message
        @receive message

exports.use = (robot) ->
  new SkypeAdapter robot
