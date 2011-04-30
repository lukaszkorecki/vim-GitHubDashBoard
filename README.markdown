# See your github dashboard in Vim!

I know you always wanted to do it!


## Requirements

- vim >= 7.2 with Ruby support (check with `:version` and look for `+ruby`)
- curl
- `json` gem installed for the ruby interpreter Vim is using (on OSX it's the system ruby)

## How to use it?

- `:GitDashGet` - opens new location list with latest events from your Github dashboard
- when selecting an item `:GitDashOpen` opens your default web browser and takes you to the linked event (like a commit comment or watched repo)


### todo

- screenshot
- open event in browser


## Licence

MIT or something like that
