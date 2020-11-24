require "nokogiri"
require "fastlane/plugin/xambuild/helpers/msbuild/project"
require "fastlane/plugin/xambuild/helpers/msbuild/solution_parser"

module Xambuild
  class DetectValues

    def self.set_additional_default_values
      config = Xambuild.config

      # TODO: detect_platform automatically for :platform config

      if config[:platform] == Platform::ANDROID
        config[:build_platform] = "AnyCPU"
      end

      # Detect the project
      Xambuild.project = Msbuild::Project.new(config)
      detect_solution
      detect_project

      doc_csproj = get_parser_handle config[:project_path]

      detect_output_path doc_csproj
      detect_manifest doc_csproj
      detect_info_plist
      detect_assembly_name doc_csproj

      config
    end

    # Helper Methods

    def self.detect_solution
      return if Xambuild.config[:solution_path]

      sln = find_file("*.sln", 3)
      UI.user_error! "Not able to find solution file automatically, try to specify it via `solution_path` parameter." unless sln

      Xambuild.config[:solution_path] = abs_path sln
    end

    def self.detect_project
      return if Xambuild.config[:project_path]

      path = Xambuild.config[:solution_path]
      projects = Msbuild::SolutionParser.parse(path)
        .get_platform Xambuild.config[:platform]

      UI.user_error! "Not able to find any project in solution, that matches the platform `#{Xambuild.config[:platform]}`." unless projects.any?

      project = projects.first
      csproj = fix_path_relative project.project_path

      UI.user_error! "Not able to find project file automatically, try to specify it via `project_path` parameter." unless csproj

      Xambuild.config[:project_name] = project.project_name
      Xambuild.config[:project_path] = abs_path csproj
    end

    def self.detect_output_path(doc_csproj)
      return if Xambuild.config[:output_path]

      configuration = Xambuild.config[:build_configuration]
      platform = Xambuild.config[:build_platform]

      doc_node = doc_csproj.xpath("/*[local-name()='Project']/*[local-name()='PropertyGroup'][translate(@*[local-name() = 'Condition'],'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz') = \" '$(configuration)|$(platform)' == '#{configuration.downcase}|#{platform.downcase}' \"]/*[local-name()='OutputPath']/text()")
      output_path = doc_node.text
      UI.user_error! "Not able to find output path automatically, try to specify it via `output_path` parameter." unless output_path

      Xambuild.config[:output_path] = abs_project_path output_path
    end

    def self.detect_manifest(doc_csproj)
      return if Xambuild.config[:manifest_path] || (Xambuild.config[:platform] != Platform::ANDROID)

      doc_node = doc_csproj.css("AndroidManifest").first

      Xambuild.config[:manifest_path] = abs_project_path doc_node.text
    end

    def self.detect_info_plist
      return if Xambuild.config[:plist_path] || (Xambuild.config[:platform] != Platform::IOS)

      plist_path = find_file("Info.plist", 1)
      UI.user_error! "Not able to find Info.plist automatically, try to specify it via `plist_path` parameter." unless plist_path

      Xambuild.config[:plist_path] = abs_project_path plist_path
    end

    def self.detect_assembly_name(doc_csproj)
      return if Xambuild.config[:assembly_name]

      if [Platform::IOS, Platform::OSX].include? Xambuild.config[:platform]
        Xambuild.config[:assembly_name] = doc_csproj.css("PropertyGroup > AssemblyName").text
      elsif Xambuild.config[:platform] == Platform::ANDROID
        doc = get_parser_handle Xambuild.config[:manifest_path]
        Xambuild.config[:assembly_name] = doc.xpath("string(//manifest/@package)")
      end
    end

    private_class_method

    def self.find_file(query, depth)
      itr = 0
      files = []

      loop do
        files = Dir.glob(query)
        query = "../#{query}"
        itr += 1
        break if files.any? || (itr > depth)
      end

      files.first
    end

    def self.get_parser_handle(filename)
      f = File.open(filename)
      doc = Nokogiri::XML(f)
      f.close

      doc
    end

    def self.fix_path_relative(path)
      root = File.dirname Xambuild.config[:solution_path]
      path = "#{root}/#{path}"
      path
    end

    def self.abs_project_path(path)
      path = path.tr('\\', "/")
      platform_path = Xambuild.config[:project_path]
      path = "#{File.dirname platform_path}/#{path}"
      path
    end

    def self.abs_path(path)
      path = path.tr('\\', "/")
      path = File.expand_path(path)
      path
    end
  end
end
