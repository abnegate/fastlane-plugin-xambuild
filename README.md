# Xambuild Fastlane Plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-xambuild) [![Gem Version](https://badge.fury.io/rb/fastlane-plugin-xambuild.svg)](https://badge.fury.io/rb/fastlane-plugin-xambuild)

## Getting Started

This project is a [fastlane](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-xambuild`, add it to your project by running:

```bash
fastlane add_plugin xambuild
```

## Example

Check out the following lanes or the [example `Fastfile`](fastlane/Fastfile) to see how to use xambuild.

```ruby
platform :ios do
  lane :example do
    xambuild(
      platform: "ios",
      build_configuration: "Release",
      plist_path: "iOS/Info.plist"
    )
  end
end
platform :android do
  lane :example do
    xambuild(
      platform: "android",
      build_configuration: "Release",
      keystore_path: "my.keystore",
      keystore_alias: "myalias",
      keystore_password: ENV["MY_KEYSTORE_PASSWORD"]
    )
  end
end
```

## About xambuild

Fastlane plugin to make Xamarin builds easy

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using `fastlane` Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About `fastlane`

`fastlane` is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).
