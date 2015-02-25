# Description:
#   Reacts appropriately to the mention of Frau Blucher
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   frau blucher
#
# Author:
#   Jeff Warner
#

module.exports = (robot) ->
  robot.hear /frau blucher/i, (msg) ->
    msg.send "https://gs1.wac.edgecastcdn.net/8019B6/data.tumblr.com/tumblr_lxkdgetMlM1qaleyd.gif"
