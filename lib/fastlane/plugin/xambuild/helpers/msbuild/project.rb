module Xambuild
  module Msbuild
    class Project
      attr_accessor :options

      def initialize(options)
        @options = options
      end

      def project_name
        @options[:project_name]
      end

      def project_path
        @options[:project_path]
      end

      def ios?
        is_platform? Xambuild::Platform::IOS
      end

      def osx?
        is_platform? Xambuild::Platform::OSX
      end

      def android?
        is_platform? Xambuild::Platform::ANDROID
      end

      def is_platform?(platform)
        case platform
               when Xambuild::Platform::IOS
            then project_name.downcase.include? "ios"
               when Xambuild::Platform::OSX
            then project_name.downcase.include? "mac"
               when Xambuild::Platform::ANDROID
            then project_name.downcase.include? "droid"
               else false
        end
      end
    end
  end
end
