# hn_app [![Build Status](https://api.cirrus-ci.com/github/filiph/hn_app.svg)](https://cirrus-ci.com/github/filiph/hn_app)

A HackerNews reader app in Flutter.

## Development

If the `Article` API gets changed, you should run:

`$ flutter packages pub run build_runner build --delete-conflicting-outputs`

The currently configured dependencies are not compatible with Flutter 2+

To build and run this project locally, please install a Flutter 1 SDK.
If using FVM, this can be done with the following commands:
```shell
fvm install 1.22.6
fvm use 1.22.6
fvm flutter pub get
```

## FVM

For faster switching between versions of Flutter, this app uses
the community tool called [fvm](https://github.com/leoafarias/fvm).

You don't need to use it, but if you want to, then install the tool
and then run everything with `fvm` (e.g. `fvm flutter build`). Read the tool's
[README](https://github.com/leoafarias/fvm) for more information.

## TODO
* Dark mode theme doesn't change text color on Android leading to white-on-white which makes the list look blank.
* Changing StoryType while viewing comments or story does not return to list.
* If articles are not previously cached, changing StoryType while viewing comments or story will not load
articles upon return to list.
