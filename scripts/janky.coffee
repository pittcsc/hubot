URL  = require "url"
url  = URL.parse(process.env.HUBOT_JANKY_URL)
HTTP = require(url.protocol.replace(/:$/, ""))

defaultOptions = () ->
  auth = new Buffer(url.auth).toString("base64")
  template =
    host: url.hostname
    port: url.port || 80
    path: url.pathname
    headers:
      "Authorization": "Basic #{auth}"

buildStatusMessages = (builds) ->
  buildsLength = builds.length
  response = ""

  if buildsLength > 0
    builds.forEach (build) ->
      response += buildStatusMessage(build)
      response += "\n" if buildsLength > 1

  response

buildStatusMessage = (build) ->
  response = "Build ##{build.number} (#{build.sha1}) of #{build.repo}/#{build.branch} #{build.status}"
  response += "(#{build.duration}s) #{build.compare}"
  response += " [Log: #{build.web_url}]"

get = (path, params, cb) ->
  options = defaultOptions()
  options.path += path
  console.log(options)
  req = HTTP.request options, (res) ->
    body = ""
    res.setEncoding("utf8")
    res.on "data", (chunk) ->
      body += chunk
    res.on "end", () ->
      cb null, res.statusCode, body
  req.on "error", (e) ->
    console.log(e)
    cb e, 500, "Client Error"
  req.end()

put = (path, params, cb) ->
  post path, params, cb, 'PUT'

post = (path, params, cb, method='POST') ->
  bodyParams     = JSON.stringify params

  options        = defaultOptions()
  options.path   = "/_hubot/#{path}"
  options.method = method
  options.headers['Content-Length'] = bodyParams.length

  req = HTTP.request options, (res) ->
    body = ""
    res.setEncoding("utf8")
    res.on "data", (chunk) ->
      body += chunk
    res.on "end", () ->
      cb null, res.statusCode, body
  req.on "error", (e) ->
    console.log(e)
    cb e, 500, "Client Error"
  req.end(bodyParams)

del = (path, params, cb) ->
  post path, params, cb, 'DELETE'

module.exports = (robot) ->
  robot.respond /ci\??$/i, (msg) ->
    get "help", { }, (err, statusCode, body) ->
      reply = if statusCode is 200
        body
      else
        "Sorry, I couldn't get the CI help."

      msg.send(reply)

  robot.respond /ci build ([-_\.0-9a-zA-Z]+)(\/([-_\+\.a-zA-z0-9\/]+))?/i, (msg) ->
    app = msg.match[1]
    branch = msg.match[3] || "master"
    roomId = msg.message.user.room
    user = msg.message.user.name.replace(/\ /g, "+")

    post "#{app}/#{branch}?room_id=#{roomId}&user=#{user}", {}, (err, statusCode, body) ->
      reply = if statusCode is 201
        "Going ham on #{app}/#{branch}!"
      else if statusCode is 404
        body
      else
        "Sorry, I couldn't build #{app}."

      msg.send(reply)

  robot.respond /ci setup ([\.\-\/_a-z0-9]+)(\s([\.\-_a-z0-9]+)(\s([\.\-_a-z0-9]+))?)?/i, (msg) ->
    nwo = msg.match[1]
    params = "?nwo=#{nwo}"

    params += "&name=#{name}" if name = msg.match[3]
    params += "&template=#{template}" if template = msg.match[5]

    post "setup#{params}", {}, (err, statusCode, body) ->
      reply = if statusCode is 201
        "OK, I set up #{app} for CI!"
      else
        "Sorry, I couldn't set up CI for that project."

      msg.send(reply)

  robot.respond /ci toggle ([-_\.0-9a-zA-Z]+)/i, (msg) ->
    app = msg.match[1]

    post "toggle/#{app}", { }, (err, statusCode, body) ->
      reply = if statusCode is 200
        body
      else
        "Sorry, I couldn't toggle CI for that project."

      msg.send(reply)

  robot.respond /ci set room ([-_0-9a-zA-Z\.]+) (.*)$/i, (msg) ->
    app = msg.match[1]
    room = msg.match[2]

    put "#{app}?room=#{encodeURIComponent(room)}", {}, (err, statusCode, body) ->
      reply = if statusCode is 200
        "Room for #{app} updated to #{room}."
      else if statusCode in [404, 403]
        body
      else
        "Hmm, I couldn't update the room for #{app}!"

      msg.send(reply)

  robot.respond /ci set context ([-_0-9a-zA-Z\.]+) (.*)$/i, (msg) ->
    repo = msg.match[1]
    context = encodeURIComponent(msg.match[2])

    put "#{repo}/context?context=#{context}", {}, (err, statusCode, body) ->
      reply = if [404, 403, 200].indexOf(statusCode) > -1
        body
      else
        "I couldn't update the context. Sorry!"

      msg.send(reply)

  robot.respond /ci unset context ([-_0-9a-zA-Z\.]+)$/i, (msg) ->
    repo = msg.match[1]

    del "#{repo}/context", {}, (err, statusCode, body) ->
      reply = if [404, 403, 200].indexOf(statusCode) > -1
        body
      else
        "Whoops, I couldn't unset the context."

      msg.send(reply)

  robot.respond /ci rooms$/i, (msg) ->
    get "rooms", { }, (err, statusCode, body) ->
      reply = if statusCode is 200
        rooms = JSON.parse body
        rooms.join ", "
      else
        "I can't predict rooms right now."

    msg.send(reply)

  robot.respond /ci builds ([0-9]+) (building)?$/i, (msg) ->
    limit = msg.match[1]
    building = msg.match[2]?

    get "builds?limit=#{limit}&building=#{building}", {}, (err, statusCode, body) ->
      builds = JSON.parse(body)
      reply = buildStatusMessages(builds) || "Builds? What builds?"

      msg.send(reply)

  robot.respond /ci status( (\*\/[-_\+\.a-zA-z0-9\/]+))?$/i, (msg) ->
    path = if msg.match[2] then "/#{msg.match[2]}" else ""

    get path, {}, (err, statusCode, body) ->
      reply = if statusCode is 200
        """
        Here are the latest build statuses:

        #{body}
        """
      else
        "Couldn't get any statuses. Maybe something's wrong."

      msg.send(reply)

  robot.respond /ci show ([-_\.0-9a-zA-Z]+)/i, (msg) ->
    app = msg.match[1]

    get "show/#{app}", { }, (err, statusCode, body) ->
      reply = if statusCode is 200
        repo = JSON.parse(body)
        lines = "#{key}: #{val}" for key, val of repo

        lines.join("\n")
      else
        "Sorry, I can't seem to show that right now."

      msg.send(reply)

  robot.respond /ci delete ([-_\.0-9a-zA-Z]+)/i, (msg) ->
    app = msg.match[1]

    del app, {}, (err, statusCode, body) ->
      reply = if statusCode is 200
        "Successfully deleted the CI project for #{app}."
      else
        "I couldn't delete that!"

      msg.send(body)
