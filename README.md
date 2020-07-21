# hn_app [![Build Status](https://api.cirrus-ci.com/github/filiph/hn_app.svg)](https://cirrus-ci.com/github/filiph/hn_app)

A HackerNews reader app in Flutter.

## Development

If the `Article` API gets changed, you should run:

`$ flutter packages pub run build_runner build --delete-conflicting-outputs`

## FVM

For faster switching between versions of Flutter, this app uses
the community tool called [fvm](https://github.com/leoafarias/fvm).

You don't need to use it, but if you want to, then install the tool
and then run everything with `fvm` (e.g. `fvm flutter build`). Read the tool's
[README](https://github.com/leoafarias/fvm) for more information.
