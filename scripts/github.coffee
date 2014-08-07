util = require 'util'

module.exports = (robot) ->
  handlePageBuild = (details) ->
    if build = details.build and repository = details.repository
      pusher = build.pusher?.login
      commit = build.commit?.substring(0, 10)

      message = if build.status is 'built'
        "Successful GitHub Pages build for `#{repository.full_name}` at `#{commit}` by #{pusher}."
      else if error = build.error
        """
        Failed GitHub Pages build for `#{repository.full_name}` at `#{commit}` by #{pusher}:

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
