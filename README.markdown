# See your github dashboard in Vim!

I know you always wanted to do it!

![screenshot](https://img.skitch.com/20110519-dqjm4pstc7fffn7r7p3t2wm22q.png)

## Requirements

- vim >= 7.2 with Ruby support (check with `:version` and look for `+ruby`)
- curl
- `json` gem installed for the ruby interpreter Vim is using (on OSX it's the system ruby)
- your `~/.gitconfig` needs to be properly [set-up to work with GitHub ](http://help.github.com/git-email-settings/)

## Installation

Get [Pathogen](httsp://github.com/tpope/vim-pathogen)

You'll know the rest.



## How to use it?

`:GithubDash` - opens new location list with latest events from your Github dashboard


`<leader>o` opens current event in default web browser
`<leader>u` opens user profile if the current word is a @username

### Issues

- none at the moment :-)

## Licence

MIT or something like that
