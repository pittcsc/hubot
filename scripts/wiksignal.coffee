# Description:
#   Summon Ritwik!
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot summon the wikman
#   hubot use the wik signal
#   hubot summon ritwik

module.exports = (robot) ->
  robot.respond /summon the wikman/i, (msg) ->
      msg.send "http://i.imgur.com/tQIZjdr.jpg @ritwik"

  robot.respond /use the wik signal/i, (msg) ->
      msg.send "http://i.imgur.com/tQIZjdr.jpg @ritwik"

  robot.respond /summon ritwik/i, (msg) ->
      msg.send "http://i.imgur.com/tQIZjdr.jpg @ritwik"
