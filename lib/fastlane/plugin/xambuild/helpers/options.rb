require "fastlane"

module Xambuild
  class Options
    def self.available_options
      [
        FastlaneCore::ConfigItem.new(key: :silent,
                                     env_name: "XAMBUILD_SILENT",
                                     description: "Hide all information that's not necessary while building",
                                     default_value: false,
                                     is_string: false),

        FastlaneCore::ConfigItem.new(key: :compiler_bin,
                                     env_name: "XAMBUILD_COMPILER_BIN",
                                     description: "Path to the compiler binary",
                                     default_value: "msbuild"),

        FastlaneCore::ConfigItem.new(key: :build_configuration,
                                     env_name: "XAMBUILD_BUILD_CONFIGURATION",
                                     description: "Build configuration value",
                                     default_value: "Release"),

        FastlaneCore::ConfigItem.new(key: :build_platform,
                                     env_name: "XAMBUILD_BUILD_PLATFORM",
                                     description: "Build platform value",
                                     default_value: "iPhone"),

        FastlaneCore::ConfigItem.new(key: :build_target,
                                     env_name: "XAMBUILD_BUILD_TARGET",
                                     description: "Build targets to build",
                                     default_value: ["Build"],
                                     type: Array),

        FastlaneCore::ConfigItem.new(key: :extra_build_options,
                                     env_name: "XAMBUILD_EXTRA_BUILD_OPTIONS",
                                     description: "Extra options to pass to `msbuild`. Example: `/p:MYOPTION=true`",
                                     optional: true),

        FastlaneCore::ConfigItem.new(key: :output_path,
                                     env_name: "XAMBUILD_BUILD_OUTPUT_PATH",
                                     description: "Build output path",
                                     optional: true),

        FastlaneCore::ConfigItem.new(key: :project_name,
                                     env_name: "XAMBUILD_BUILD_PROJECT_NAME",
                                     description: "Build project name",
                                     optional: true),

        FastlaneCore::ConfigItem.new(key: :assembly_name,
                                     env_name: "XAMBUILD_BUILD_ASSEMBLY_NAME",
                                     description: "Build assembly name",
                                     optional: true),

        FastlaneCore::ConfigItem.new(key: :platform,
                                     env_name: "XAMBUILD_PLATFORM",
                                     description: "Targeted device platform (i.e. android, ios, osx)",
                                     optional: false),

        FastlaneCore::ConfigItem.new(key: :solution_path,
                                     env_name: "XAMBUILD_SOLUTION_PATH",
                                     description: "Path to the build solution (sln) file",
                                     optional: true),

        FastlaneCore::ConfigItem.new(key: :project_path,
                                     env_name: "XAMBUILD_PROJECT_PATH",
                                     description: "Path to the build project (csproj) file",
                                     optional: true),

        FastlaneCore::ConfigItem.new(key: :manifest_path,
                                     env_name: "XAMBUILD_ANDROID_MANIFEST_PATH",
                                     description: "Path to the android manifest (xml) file",
                                     optional: true),

        FastlaneCore::ConfigItem.new(key: :plist_path,
                                     env_name: "XAMBUILD_IOS_PLIST_PATH",
                                     description: "Path to the iOS plist file",
                                     optional: true),

        FastlaneCore::ConfigItem.new(key: :keystore_path,
                                     env_name: "XAMBUILD_ANDROID_KEYSTORE_PATH",
                                     description: "Path to the keystore",
                                     optional: true),

        FastlaneCore::ConfigItem.new(key: :keystore_alias,
                                     env_name: "XAMBUILD_ANDROID_KEYSTORE_ALIAS",
                                     description: "Alias of the keystore",
                                     optional: true),

        FastlaneCore::ConfigItem.new(key: :keystore_password,
                                     env_name: "XAMBUILD_ANDROID_KEYSTORE_PASSWORD",
                                     description: "Password of the keystore",
                                     optional: true),
        
        FastlaneCore::ConfigItem.new(key: :keystore_tsa,
                                     default_value: "http://timestamp.digicert.com",
                                     env_name: "XAMBUILD_ANDROID_KEYSTORE_TSA",
                                     description: "TSA for jarsigner",
                                     optional: true)
      ]
    end
  end
end
