# frozen_string_literal: true

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "fastlane/plugin/xambuild/version"

Gem::Specification.new do |spec|
  spec.name = "fastlane-plugin-xambuild"
  spec.version = Fastlane::Xambuild::VERSION
  spec.author = "Jake Barnby"
  spec.email = "jakeb994@gmail.com"

  spec.summary = "Fastlane plugin to make Xamarin builds easy"
  spec.homepage = "https://github.com/abnegate/fastlane-plugin-xambuild"
  spec.license = "MIT"

  spec.files = Dir["lib/**/*"] + %w[README.md LICENSE]
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "nokogiri", "~> 1.7"
  spec.add_dependency "csproj", "~> 0.1.1"

  spec.add_development_dependency("bundler")
  spec.add_development_dependency("fastlane", ">= 2.169.0")
  spec.add_development_dependency("pry")
  spec.add_development_dependency("rake")
  spec.add_development_dependency("rspec")
  spec.add_development_dependency("rspec_junit_formatter")
  spec.add_development_dependency("rubocop", "0.49.1")
  spec.add_development_dependency("rubocop-require_tools")
  spec.add_development_dependency("simplecov")
end
