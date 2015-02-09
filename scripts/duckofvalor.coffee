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
#   duckofvalor
#
# Author:
#   Ritwik Gupta
#

module.exports = (robot) ->
  robot.hear /duck of valor/i, (msg) ->
    msg.send "http://i.imgur.com/MoiShv2.png"
