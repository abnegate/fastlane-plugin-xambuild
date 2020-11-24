module Xambuild
  class AndroidZipalignCommandGenerator
    class << self
      def generate
        parts = prefix
        parts << zipalign_apk
        parts += options
        parts << Xambuild.cache[:signed_apk_path]
        parts << Xambuild.cache[:build_apk_path]
        parts += pipe

        parts
      end

      def detect_build_tools
        UI.user_error! "Please ensure that the Android SDK is installed and the ANDROID_HOME variable is set correctly" unless ENV["ANDROID_HOME"]

        buildtools = File.join(ENV["ANDROID_HOME"], "build-tools")
        version = Dir.entries(buildtools).max

        UI.success "Using Buildtools Version: #{version}..."

        [buildtools, version]
      end

      def zipalign_apk
        buildtools, version = detect_build_tools
        zipalign = ENV["ANDROID_HOME"] ? File.join(buildtools, version, "zipalign") : "zipalign"

        zipalign
      end

      def options
        options = []
        options << "-v" if $verbose
        options << "-f"
        options << "4"

        options
      end

      def prefix
        [""]
      end

      def pipe
        pipe = []

        pipe
      end
    end
  end
end
