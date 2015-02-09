# Description:
#   Summons the Duck of Valor.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   duck of valor
#
# Author:
#   Ritwik Gupta
#

module.exports = (robot) ->
  robot.hear /duck of valor/i, (msg) ->
    msg.send "http://i.imgur.com/MoiShv2.png"
