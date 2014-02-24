# Iron Blogger

This is a simple Rails app designed to help coordinate an [Iron Blogger](http://blog.lazerwalker.com/blog/2013/12/24/one-post-a-week-running-an-iron-blogger-challenge/) competition.

Warning: this is very simple, untested code. Use at your own peril.

# Installation
This is a bog standard Rails app. Clone the repo, then all the usual steps: `bundle install`, `bundle exec rake db:setup` to set it up locally, then `rails s` to start a local server.

It's also ready to deploy as-is to Heroku.

# Usage
Going to the root URL gives you an up-to-date index of everything, with a link to create a new blogger.
Going to `/email` gives you the HTML for a weekly email, ready to copy/paste into your mail client of choice.

There's currently no web UI for editing users other than the creation screen; any updating or deleting users needs to happen from the CLI or raw DB access (e.g. a `rails c` instance).

Additionally, nothing is persisted to the database other than each user's name and RSS feed; all feed data is fetched anew when you load a page. Yes, this is terrible.

# License
MIT License. See the "LICENSE" file in the root of this project.

