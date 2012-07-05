# hubot-skype

Hubot Adapter for Skype written in Ruby

## Disclaimer

* You must have access to the [Skype Developer SDK](http://developer.skype.com/) for this to work.
Note that the Skype Developer SDK costs $5 (one-time fee) to attain.
This adapter for Hubot is open-source, and is MIT-licensed, but the Skype SDK is not. Please refer to the Skype SDK license for futher information.

* Due credit goes out to [Dominick D'Aniello](https://github.com/netpro2k/hubot-skype) for his work on the hubot-skype adapter. This project was inspired by his work, but is written in Ruby using [libskypekit](https://github.com/railsware/libskypekit) and the [skypekit gem](https://github.com/railsware/skypekit).

## Dependencies
* [SkypeKit SDK](http://developer.skype.com/)
* [libskypekit](https://github.com/railsware/libskypekit)
* [skypekit gem](https://github.com/railsware/skypekit)
* [Redis](https://github.com/redis/redis-rb)

## Installation

1. Acquire the SkypeKit SDK (as of this writing, the current version of the SDK is 4.2)
2. Acquire the Skype Runtime application (also from the Skype Developer site)
3. Acquire a keypair from Skype for development (also from the Skype Developer site)
4. SkypeKit SDK 
    * Compiling requires CMake. If you are on OS X, you can use [Homebrew](http://mxcl.github.com/homebrew/) to install it.
    * Run `BuildWithCmake.sh` in `$SDK_DIR/interfaces/skype/cpp_embedded`
    * Consult the [Skype SDK documentation](http://developer.skype.com/) for further details if you are having issues.
5. libskypekit
    * `git clone git@github.com:railsware/libskypekit.git`
    * Compile: `DEBUG=1 SKYPEKIT_SDK=$SDK_DIR ./build.sh`
    * Install:
        * `sudo ./install.sh`
    * Consult the [libskypekit page](https://github.com/railsware/libskypekit) if you have any issues.

6. Include hubot-skype as part of your Hubot's package.json dependencies: 
    * `"hubot-skype": "git+ssh://git@github.com:hahuang65/hubot-skype.git"`
7. Run `npm install` for Hubot.
8. Configuration
    * Setting up Skype username and password (this step will be improved in the future)
        * In the `src/skype.rb` file, find this line: `$skype.login(skype_username, skype_password)`
        * Set the `skype_username` variable to the desired value
        * Set the `skype_password` variable to the desired value
    * Move your Skype Developer keypair to the skype-hubot folder
        * The `keypair.cer` file should be at the same level as the `src` folder.
9. skypekit gem
    * `gem install skypekit`
    * NOTE: if you are using an older version of the skypekit gem for whatever reason (< v0.0.2), you'll have to make a symlink to the dylib.
        * On my machine, it looked like: `ln -s /usr/local/lib/libskypekit.1.dylib /usr/local/lib/libskypekit.so.1.dylib`
10. Redis
    * `gem install redis`

## Usage
1. Start up your Skype runtime
2. Start up Hubot with the Skype adapter
    * Make sure Redis is running
    * `$HUBOT_DIR/bin/hubot -a skype`


## Author

* Howard Huang

## License

* Copyright (c) 2012 Howard Huang
* [MIT](www.opensource.org/licenses/MIT)