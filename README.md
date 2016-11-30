# ElastaBot


## Installation

```
 mix deps.get
```

Create an environment variable `export SLACK_TOKEN=xoxo-SLACK-API-TOKEN`. For more info checkout the [slack docs](https://api.slack.com/bot-users).

`.env` file is part of the .gitignore file.  Would suggest addint the export to that and sourceing that file in your current terminal session.


To run slack bot:

```
mix run --no-halt
```

## Useage

So far the elastabot responds to the word 'ping' with the word 'pong'.  The plan is that it will hook into your elastasearch and run a query for you and return the results.

The need for this is that we use [yelp's elastalert](https://github.com/Yelp/elastalert) to send alerts to slack with a kibana link.  However viewing the errors requires access to the vpn - either a number of extra steps to connect with or not easy to do when on mobile.  The bot will give you the back what n errors are allowing you to work out if you need to get back online and sort things out or if it is a non essential warning.


