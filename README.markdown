# See your github dashboard in Vim!

I know you always wanted to do it!


## Requirements

- vim >= 7.2 with Ruby support (check with `:version` and look for `+ruby`)
- curl
- `json` gem installed for the ruby interpreter Vim is using (on OSX it's the system ruby)
- your `~/.gitconfig` needs to be properly [set-up to work with GitHub ](http://help.github.com/git-email-settings/)

## How to use it?

`:GithubDash` - opens new location list with latest events from your Github dashboard

![screenshot](https://img.skitch.com/20110501-rh2ya7sjeerm8rdseuwid24m69.png)

When selecting an item `:GitHubOpen` opens your default web browser and takes you to the linked event (like a commit comment or watched repo)


### todo

- open event in browser when pressing `enter` key
- nicer formatting


## Licence

MIT or something like that
