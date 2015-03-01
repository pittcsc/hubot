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
  robot.respond /summon the wikman/i, signal
  robot.respond /use the wik signal/i, signal
  robot.respond /summon ritwik/i, signal

signal = (msg) ->
  msg.send "http://i.imgur.com/tQIZjdr.jpg <@U02JT58NK>"
