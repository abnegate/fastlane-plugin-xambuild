module Xambuild
  class ZipDsym
    class << self
      def generate
        parts = prefix
        parts << detect_zip_executable
        parts += options
        parts += pipe

        parts
      end

      def prefix
        [""]
      end

      def detect_zip_executable
        zip = ENV["XAMBUILD_ZIP_PATH"] || "zip"

        zip
      end

      def options
        build_dsym_path = CsProj.cache[:build_dsym_path]

        options = []
        options << "-r"
        options << "#{build_dsym_path}.zip"
        options << build_dsym_path

        options
      end

      def pipe
        pipe = []

        pipe
      end
    end
  end
end
