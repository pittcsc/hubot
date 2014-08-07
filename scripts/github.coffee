util = require 'util'

module.exports = (robot) ->
  handlePageBuild = (details) ->
    if build = details.build
      console.log util.inspect(build)
      repository = build.repository
      pusher = build.pusher
      commit = build.commit

      message = if details.build.status is 'built'
        "Successful GitHub Pages build for [#{repository.full_name}](#{repository.html_url}) at #{commit} by #{pusher.login}."
      else if error = details.build.error
        """
        Failed GitHub Pages build for [#{repository.full_name}](#{repository.html_url}) at #{commit} by #{pusher.login}:

        ```
        #{error.message}
        ```
        """

      robot.messageRoom('#alltalk', message)

  robot.router.post '/hubot/github_webhook', (req, res) ->
    if req.is('json')
      event = req.header('X-GitHub-Event')

      switch event
        when 'page_build' then handlePageBuild(req.body)

    res.send(200, 'ok')
