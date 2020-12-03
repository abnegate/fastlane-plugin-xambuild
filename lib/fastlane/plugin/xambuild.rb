module Fastlane
  module Xambuild
    # Return all .rb files inside the "actions" and "helper" directory
    def self.all_classes
      Dir[File.expand_path("**/{actions,helpers}/*.rb", File.dirname(__FILE__))]
    end
  end
end

# By default we want to import all available actions and helpers
# A plugin can contain any number of actions and plugins
Fastlane::Xambuild.all_classes.each do |current|
  require current
end

require "fastlane"

module Xambuild
  Helper = FastlaneCore::Helper
  UI = FastlaneCore::UI
end
