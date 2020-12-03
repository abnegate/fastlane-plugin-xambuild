module Xambuild
  class BuildCommand
    class << self
      def generate
        parts = prefix
        parts << compiler_bin
        parts += options
        parts += targets
        parts += project
        parts += pipe

        parts
      end

      def prefix
        [""]
      end

      def compiler_bin
        CsProj.config[:compiler_bin]
      end

      def options
        config = CsProj.config

        options = []
        options << config[:extra_build_options] if config[:extra_build_options]
        options << "-p:Configuration=#{config[:build_configuration]}" if config[:build_configuration]
        options << "-p:Platform=#{config[:build_platform]}" if CsProj.project.ios? && config[:build_platform]
        options << "-p:BuildIpa=true" if CsProj.project.ios?
        if config[:solution_path]
          solution_dir = File.dirname(config[:solution_path])
          options << "-p:SolutionDir=#{solution_dir}/"
        end

        options
      end

      def build_targets
        CsProj.config[:build_target].map! { |t| "-t:#{t}" }
      end

      def targets
        targets = []
        targets += build_targets
        targets << "-t:SignAndroidPackage" if CsProj.project.android?

        targets
      end

      def project
        path = []

        path << CsProj.config[:project_path]

        path
      end

      def pipe
        pipe = []

        pipe
      end
    end
  end
end
