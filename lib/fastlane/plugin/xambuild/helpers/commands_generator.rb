require "commander"
require "fastlane"

HighLine.track_eof = false

module Xambuild
  class CommandsGenerator
    include Commander::Methods
    UI = FastlaneCore::UI

    FastlaneCore::CommanderGenerator.new.generate(Xambuild::Options.available_options)

    def self.start
      new.run
    end

    def convert_options(options)
      o = options.__hash__.dup
      o.delete(:verbose)
      o
    end

    def run
      program :version, Xambuild::VERSION
      program :description, Xambuild::DESCRIPTION
      program :help, "Author", "Jake Barnby <jakeb994@gmail.com>"
      program :help_formatter, :compact

      global_option("--verbose") { $verbose = true }

      command :build do |c|
        c.syntax = "xambuild"
        c.description = "Just builds your app"
        c.action do |_args, options|
          config = FastlaneCore::Configuration.create(Xambuild::Options.available_options,
            convert_options(options))
          Xambuild::Manager.new.work(config)
        end
      end

      default_command :build

      run!
    end
  end
end
