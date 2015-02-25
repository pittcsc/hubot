module.exports = (robot) ->
  robot.hear /\b(QEMU|qemu)\b/, troll()
  robot.hear /\b(PHP|php)\b/i, troll()
  robot.hear /\b(emacs)\b/i, troll('*vim :trollface:')

troll = (reply = ':trollface:') ->
  (msg) ->
    msg.send reply

troll = (msg) ->
    msg.send ':trollface:'

trollmacs = (msg) ->
    msg.send '*vim :trollface:'
