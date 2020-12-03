require "fastlane"
require "fastlane/plugin/xambuild/helpers/runner"
require "fastlane/plugin/xambuild/version"

module Xambuild
  class Manager
    def work(options)
      CsProj.config = options

      FastlaneCore::PrintTable.print_values(config: CsProj.config,
                                            hide_keys: [],
                                            title: "Summary for xambuild #{Fastlane::Xambuild::VERSION}")

      Runner.new.run
    end
  end
end
