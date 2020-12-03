require "fastlane"
require "fastlane/plugin/xambuild/helpers/generators/build"
require "fastlane/plugin/xambuild/helpers/generators/zip_dsym"
require "fastlane/plugin/xambuild/helpers/generators/java_sign"
require "fastlane/plugin/xambuild/helpers/generators/android_zipalign"

module Xambuild
  class Runner
    def run
      config = CsProj.config

      build_app

      if CsProj.project.ios? || CsProj.project.osx?
        compress_and_move_dsym
        path = ipa_file

        path
      elsif CsProj.project.android?
        path = apk_file
        if config[:keystore_path] && config[:keystore_alias]
          UI.success "Jar it, sign it, zip it..."

          jarsign_and_zipalign
        end

        path
      end
    end

    def build_app
      command = BuildCommand.generate

      FastlaneCore::CommandExecutor.execute(command: command,
                                            print_all: true,
                                            print_command: !CsProj.config[:silent])
    end

    def apk_file
      build_path = CsProj.project.options[:output_path]
      assembly_name = CsProj.project.options[:assembly_name]

      CsProj.cache[:build_apk_path] = "#{build_path}/#{assembly_name}.apk"

      "#{build_path}/#{assembly_name}.apk"
    end

    def jarsign_and_zipalign
      command = JavaSign.generate
      FastlaneCore::CommandExecutor.execute(command: command,
                                            print_all: false,
                                            print_command: !CsProj.config[:silent])

      UI.success "Successfully signed apk #{CsProj.cache[:build_apk_path]}"

      command = AndroidZipalign.generate
      FastlaneCore::CommandExecutor.execute(command: command,
                                            print_all: true,
                                            print_command: !CsProj.config[:silent])
    end

    def package_path
      build_path = CsProj.project.options[:output_path]
      assembly_name = CsProj.project.options[:assembly_name]

      package_path = if File.exist? "#{build_path}/#{assembly_name}.ipa"
        # After Xamarin.iOS 9
        build_path
      else
        # Before Xamarin.iOS 9
        Dir.glob("#{build_path}/#{assembly_name} *").max
      end

      package_path
    end

    def ipa_file
      assembly_name = CsProj.project.options[:assembly_name]

      "#{package_path}/#{assembly_name}.ipa"
    end

    def compress_and_move_dsym
      build_path = CsProj.project.options[:output_path]
      assembly_name = CsProj.project.options[:assembly_name]

      build_dsym_path = "#{build_path}/#{assembly_name}.app.dSYM"
      unless File.exist? build_dsym_path
        UI.success "Did not found dSYM at #{build_dsym_path}, skipping..."
        return
      end

      CsProj.cache[:build_dsym_path] = build_dsym_path

      command = ZipDsym.generate
      FastlaneCore::CommandExecutor.execute(command: command,
                                            print_all: true,
                                            print_command: !CsProj.config[:silent])

      # Move dsym beside ipa
      dsym_path = "#{dsym_path}.zip"
      if File.exist? dsym_path
        FileUtils.mv(dsym_path, "#{package_path}/#{File.basename dsym_path}")
      end
    end
  end
end
