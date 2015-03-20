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
  robot.hear /^sudo make me a sandwich/i, (msg) ->
    msg.send "Relevant XKCD: http://imgs.xkcd.com/comics/sandwich.png"
