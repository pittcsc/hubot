# Description:
#   Makes the user a sandwich
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   sudo make me a sandwich
#
# Author:
#   Jeff Warner
#

module.exports = (robot) ->
  robot.hear /^sudo make me a sandwich/i, (msg) ->
    msg.send "Relevant XKCD: http://imgs.xkcd.com/comics/sandwich.png"
