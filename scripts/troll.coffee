module.exports = (robot) ->
  robot.hear /\b(QEMU|qemu)\b/, troll
  robot.hear /\b(PHP|php)\b/i, troll
  robot.hear /\b(emacs)\b/i, trollmacs

troll = (msg) ->
    msg.send ':trollface:'

trollmacs = (msg) ->
    msg.send '*vim :trollface:'
