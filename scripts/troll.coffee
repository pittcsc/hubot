module.exports = (robot) ->
  robot.hear /qemu/i, troll

troll = (msg) ->
    msg.send ':trollface:'
