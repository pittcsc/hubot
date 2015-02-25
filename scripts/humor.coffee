Path = require 'path'

module.exports = (robot) ->
  robot.load Path.resolve('.', 'scripts', 'humor')
