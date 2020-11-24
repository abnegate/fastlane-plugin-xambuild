require "fastlane"
require "fastlane/plugin/xambuild/helpers/generators/build_command_generator"
require "fastlane/plugin/xambuild/helpers/generators/zip_dsym_command_generator"
require "fastlane/plugin/xambuild/helpers/generators/java_sign_command_generator"
require "fastlane/plugin/xambuild/helpers/generators/android_zipalign_command_generator"

module Xambuild
  class Runner

    def run
      config = Xambuild.config

      build_app

      if Xambuild.project.ios? || Xambuild.project.osx?
        compress_and_move_dsym
        path = ipa_file

        path
      elsif Xambuild.project.android?
        path = apk_file
        if config[:keystore_path] && config[:keystore_alias]
          UI.success "Jar it, sign it, zip it..."

          jarsign_and_zipalign
        end

        path
      end
    end

    def build_app
      command = BuildCommandGenerator.generate

      FastlaneCore::CommandExecutor.execute(command: command,
                                            print_all: true,
                                            print_command: !Xambuild.config[:silent])
    end

    def apk_file
      build_path = Xambuild.project.options[:output_path]
      assembly_name = Xambuild.project.options[:assembly_name]

      Xambuild.cache[:build_apk_path] = "#{build_path}/#{assembly_name}.apk"

      "#{build_path}/#{assembly_name}.apk"
    end

    def jarsign_and_zipalign
      command = JavaSignCommandGenerator.generate
      FastlaneCore::CommandExecutor.execute(command: command,
                                            print_all: false,
                                            print_command: !Xambuild.config[:silent])

      UI.success "Successfully signed apk #{Xambuild.cache[:build_apk_path]}"

      command = AndroidZipalignCommandGenerator.generate
      FastlaneCore::CommandExecutor.execute(command: command,
                                            print_all: true,
                                            print_command: !Xambuild.config[:silent])
    end

    def package_path
      build_path = Xambuild.project.options[:output_path]
      assembly_name = Xambuild.project.options[:assembly_name]

      package_path = if File.exist? "#{build_path}/#{assembly_name}.ipa"
        # after Xamarin.iOS Cycle 9
        build_path
      else
        # before Xamarin.iOS Cycle 9
        Dir.glob("#{build_path}/#{assembly_name} *").max
      end

      package_path
    end

    def ipa_file
      assembly_name = Xambuild.project.options[:assembly_name]

      "#{package_path}/#{assembly_name}.ipa"
    end

    def compress_and_move_dsym
      build_path = Xambuild.project.options[:output_path]
      assembly_name = Xambuild.project.options[:assembly_name]

      build_dsym_path = "#{build_path}/#{assembly_name}.app.dSYM"
      unless File.exist? build_dsym_path
        UI.success "Did not found dSYM at #{build_dsym_path}, skipping..."
        return
      end

      Xambuild.cache[:build_dsym_path] = build_dsym_path

      command = ZipDsymCommandGenerator.generate
      FastlaneCore::CommandExecutor.execute(command: command,
                                            print_all: true,
                                            print_command: !Xambuild.config[:silent])

      # move dsym aside ipa
      dsym_path = "#{dsym_path}.zip"
      if File.exist? dsym_path
        FileUtils.mv(dsym_path, "#{package_path}/#{File.basename dsym_path}")
      end
    end
  end
end
