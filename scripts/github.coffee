module.exports = (robot) ->
  ROOMS = ['#alltalk']

  handlePageBuild = (details) ->
    if {build, repository} = details
      pusher = build.pusher?.login
      commit = build.commit?.substring(0, 10)

      message = if build.status is 'built'
        "GitHub Pages build succeeded for `#{repository.full_name}` at `#{commit}` by #{pusher}."
      else if error = build.error?.message
        """
        GitHub Pages build failed for `#{repository.full_name}` at `#{commit}` by #{pusher}:

        ```
        #{error}
        ```
        """

      if message
        robot.messageRoom(room, message) for room in ROOMS

  robot.router.post '/hubot/github_webhook', (req, res) ->
    if req.is('json')
      switch req.header('X-GitHub-Event')
        when 'page_build' then handlePageBuild(req.body)

      res.send(200)
    else
      res.send(400)
