module.exports = (robot) ->
  robot.hear /(QEMU|qemu)/, troll
  robot.hear /(PHP|php)/i, troll
  robot.hear /(emacs)/i, trollmacs

troll = (msg) ->
    msg.send ':trollface:'

trollmacs = (msg) ->
    msg.send '*vim :trollface:'
