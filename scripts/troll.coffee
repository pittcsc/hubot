module.exports = (robot) ->
  robot.hear /(QEMU|qemu)/, troll
  robot.hear /(PHP|php)/i, troll

troll = (msg) ->
    msg.send ':trollface:'
