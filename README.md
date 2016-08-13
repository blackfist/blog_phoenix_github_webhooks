# Validating GitHub Webhooks with phoenix
## TL;DR

 * GitHub hashes the raw body of their messages
 * You need to implement a custom parser to calculate the hash and still parse the JSON.
 * Attempting to to implement a plug that reads the body before the parser renders the parsers unworkable. The body is read-once.
 * This repo is an example of how to do it in Phoenix.
 * Environment variables need to be available at compile time.

## What are we going to do?

GitHub web hooks are a pretty cool way to monitor what is going on with
your code on GitHub. Want to take some automated action when someone pushes
to the master branch? Webhooks are very useful for that. However,
you don't want your application to act on just any POST request that comes in.
You need to be sure that the data your app is receiving really came from GitHub.

GitHub provides this assurance by signing the messages that it sends to you.
When you go into settings and set up a web hook you have the option of specifying
a key. GitHub will use that key to create a cryptographic hash of every message it
sends to you. When you receive a message you can calculate the hash yourself and
compare it to the hash GitHub provided thus proving that the message was sent by
some service that knows the key.

There are some challenges we need to get past, though. The biggest one is that you
have to read the body of the incoming request in its original form, in other words before
any parsers have had a chance to alter it. However, reading the body makes the body
inaccessible to anything else that needs to read the message body. So we can't just
make a simple function, we need to replace the JSON parser with a new parser that will
also create a copy of the unaltered body and put that in the `conn`. Let's get started.

## Create project and add dependencies

`mix phoenix.new github_webhooks --no-html --no-brunch`

Add this to `mix.exs`. When we compare the hash value provided by GitHub to the
hash value that we calculate we want to make sure that we're not opening ourselves up
to [timing attacks](https://codahale.com/a-lesson-in-timing-attacks/). So we need to do
a secure comparison instead of a simple `==`.

`{:secure_compare, "~> 0.0.1"},`

and run `mix deps.get`

## Create an endpoint for the webhooks.
