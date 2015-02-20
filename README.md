# Hubot

This is Pitt CSC's version of GitHub's chat bot, hubot. It's pretty cool.


### Testing Hubot Locally

You can test hubot in your shell by running `bin/hubot`.

You'll see some startup output and a prompt:

    [Sun, 04 Dec 2011 18:41:11 GMT] INFO Loading adapter shell
    [Sun, 04 Dec 2011 18:41:11 GMT] INFO Loading scripts from /home/tomb/Development/hubot/scripts
    [Sun, 04 Dec 2011 18:41:11 GMT] INFO Loading scripts from /home/tomb/Development/hubot/src/scripts
    Hubot>

Then you can interact with hubot:

    Hubot> hubot help

    Hubot> Events:
    animate me <query> - The same thing as `image me`, except adds a few
    convert me <expression> to <units> - Convert expression to given units.
    help - Displays all of the help commands that Hubot knows about.
    ...


## Scripting

Read more on what you can do with hubot in the [Scripting Guide](https://github.com/github/hubot/blob/master/docs/scripting.md).


## Deployment

Our hubot is hosted on [Heroku](https://heroku.com). If you have deployment permissions, you can deploy hubot updates by pushing to Heroku:

    git push heroku master

Please don't deploy any changes that haven't been pushed to GitHub yet.

### Configuration

Hubot's behavior on Heroku is configured via several environment variables:

    HEROKU_URL:        [...]
    HUBOT_SLACK_TOKEN: [...]

Changing any of these variables will require restarting the hubot application.

### Troubleshooting

In the event that hubot crashes, anyone with deployment permissions may restart it or diagnose the problem using the [Heroku Toolbelt](https://toolbelt.heroku.com/):

    heroku restart
    heroku logs
