module.exports = (robot) ->
  ROOMS = ['#alltalk']

  receivePageBuild = (details) ->
    if {build, repository, error} = details
      message = generatePageBuildMessage({build, repository, error})
      robot.messageRoom(room, message) for room in ROOMS

  generatePageBuildMessage = ({build, repository, error}) ->
    pusher = build.pusher.login
    commit = build.commit.substring(0, 10)

    switch build.status
      when 'build'
        "GitHub Pages build succeeded for `#{repository.full_name}` at `#{commit}` by #{pusher}."
      when 'errored'
        """
        GitHub Pages build failed for `#{repository.full_name}` at `#{commit}` by #{pusher}:

        ```
        #{error.message}
        ```
        """
      else
        "GitHub Pages build finished with unknown status for `#{repository.full_name}` at `#{commit}` by #{pusher}."

  robot.router.post '/hubot/github_webhook', (req, res) ->
    if req.is('json')
      switch req.header('X-GitHub-Event')
        when 'page_build' then receivePageBuild(req.body)

      res.send(200)
    else
      res.send(400)
