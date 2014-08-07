util = require 'util'

module.exports = (robot) ->
  handlePageBuild = (details) ->
    if build = details.build
      repository_name = details.repository?.full_name
      pusher = build.pusher
      commit = build.commit.substring(0, 10)

      message = if build.status is 'built'
        "Successful GitHub Pages build for `#{repository_name}` at `#{commit}` by #{pusher.login}."
      else if error = build.error
        """
        Failed GitHub Pages build for `#{repository_name}` at `#{commit}` by #{pusher.login}:

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
