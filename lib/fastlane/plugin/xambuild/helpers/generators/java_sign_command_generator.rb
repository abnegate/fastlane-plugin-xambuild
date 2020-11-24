module Xambuild
  class JavaSignCommandGenerator
    class << self
      def generate
        build_apk_path = Xambuild.cache[:build_apk_path]
        Xambuild.cache[:signed_apk_path] = "#{build_apk_path}-unaligned"

        parts = prefix
        parts << detect_jarsigner_executable
        parts += options
        parts << build_apk_path
        parts << Xambuild.config[:keystore_alias]
        parts += pipe

        parts
      end

      def prefix
        [""]
      end

      def detect_jarsigner_executable
        jarsigner = ENV["JAVA_HOME"] ? File.join(ENV["JAVA_HOME"], "bin", "jarsigner") : "jarsigner"

        jarsigner
      end

      def options
        config = Xambuild.config

        options = []
        options << "-verbose" if $verbose
        options << "-sigalg MD5withRSA"
        options << "-digestalg SHA1"
        options << "-storepass \"#{config[:keystore_password]}\""
        options << "-keystore \"#{config[:keystore_path]}\""
        options << "-tsa #{config[:keystore_tsa]}"
        options << "-signedjar \"#{Xambuild.cache[:signed_apk_path]}\""

        options
      end

      def pipe
        pipe = []

        pipe
      end
    end
  end
end
