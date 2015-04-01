# Description:
#   Corrects users on the proper use of Hubot
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot .*
#
# Author:
#   Jeff Warner
#

module.exports = (robot) ->
  robot.hear /^hubot .+/i, (msg) ->
    msg.send "Sorry, I'm not Hubot. Try `sudo`!"
