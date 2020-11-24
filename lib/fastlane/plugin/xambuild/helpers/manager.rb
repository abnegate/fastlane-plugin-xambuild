require "fastlane"
require "fastlane/plugin/xambuild/helpers/runner"
require "fastlane/plugin/xambuild/version"

module Xambuild
  class Manager
    def work(options)
      Xambuild.config = options

      FastlaneCore::PrintTable.print_values(config: Xambuild.config,
                                            hide_keys: [],
                                            title: "Summary for xambuild #{Fastlane::Xambuild::VERSION}")

      Runner.new.run
    end
  end
end
