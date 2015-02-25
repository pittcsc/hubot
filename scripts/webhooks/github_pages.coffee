module.exports = (robot) ->
  ROOMS =
    'pitt-csc.github.io': '#website'
    'steelhacks.com': 'steelhacks'

  receivePageBuild = (details) ->
    {repository} = details

    if room = ROOMS[repository.name]
      message = generatePageBuildMessage(details)
      robot.messageRoom(room, message)

  generatePageBuildMessage = ({build, repository, error}) ->
    pusher = build.pusher.login
    commit = build.commit.substring(0, 10)

    switch build.status
      when 'built'
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

  robot.router.post "/#{robot.name}/webhooks/github_pages", (req, res) ->
    if req.is('json')
      switch req.header('X-GitHub-Event')
        when 'page_build' then receivePageBuild(req.body)

      res.send(200)
    else
      res.send(400)
