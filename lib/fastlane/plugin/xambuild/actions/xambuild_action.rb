require "fastlane/plugin/xambuild/helpers/options"
require "fastlane/plugin/xambuild/helpers/platform"
require "fastlane/plugin/xambuild/helpers/manager"

module Fastlane
  module Actions
    module SharedValues
      # for calabash
      APP_BUNDLE_PATH = :APP_BUNDLE_PATH
      APP_OUTPUT_PATH = :APP_OUTPUT_PATH
    end

    class XambuildAction < Action

      def self.run(values)
        values[:platform] = ::Xambuild::Platform.from_lane_context(Actions.lane_context)
        ::Xambuild.config = values

        if ::Xambuild.project.ios? || ::Xambuild.project.osx?
          absolute_ipa_path = File.expand_path(::Xambuild::Manager.new.work(values))
          absolute_app_path = File.join(values[:output_path], "#{values[:assembly_name]}.app")
          absolute_dsym_path = absolute_ipa_path.gsub(".ipa", ".app.dSYM.zip")

          Actions.lane_context[SharedValues::APP_OUTPUT_PATH] = absolute_app_path
          Actions.lane_context[SharedValues::IPA_OUTPUT_PATH] = absolute_ipa_path
          Actions.lane_context[SharedValues::DSYM_OUTPUT_PATH] = absolute_dsym_path if File.exist?(absolute_dsym_path)
          ENV[SharedValues::APP_OUTPUT_PATH.to_s] = absolute_app_path
          ENV[SharedValues::APP_BUNDLE_PATH.to_s] = absolute_app_path # for calabash
          ENV[SharedValues::IPA_OUTPUT_PATH.to_s] = absolute_ipa_path # for deliver
          ENV[SharedValues::DSYM_OUTPUT_PATH.to_s] = absolute_dsym_path if File.exist?(absolute_dsym_path)

          absolute_ipa_path
        elsif ::Xambuild.project.android?
          if values[:keystore_path] && values[:keystore_alias]
            unless values[:keystore_password]
              ::Xambuild.config[:keystore_password] = ask("Password (for #{values[:keystore_alias]}): ") { |q| q.echo = "*" }
            end
          end
          absolute_apk_path = File.expand_path(::Xambuild::Manager.new.work(values))

          Actions.lane_context[SharedValues::GRADLE_BUILD_TYPE] = values[:build_configuration]
          Actions.lane_context[SharedValues::GRADLE_APK_OUTPUT_PATH] = absolute_apk_path

          absolute_apk_path
        end
      end

      def self.description
        "Easily build and sign your Xamarin iOS or Android app using `xambuild`"
      end

      def self.return_value
        "The absolute path to the generated app file"
      end

      def self.author
        "Jake Barnby"
      end

      def self.available_options
        ::Xambuild::Options.available_options
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
