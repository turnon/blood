# frozen_string_literal: true

require_relative "lib/blood/version"

Gem::Specification.new do |spec|
  spec.name          = "blood"
  spec.version       = Blood::VERSION
  spec.authors       = ["ken"]
  spec.email         = ["block24block@gmail.com"]

  spec.summary       = "Display bloodline of classes"
  spec.homepage      = "https://github.com/turnon/blood"
  spec.license       = "MIT"
  # spec.required_ruby_version = Gem::Requirement.new(">= 2.4.0")

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "tree_html", "~> 0.1.10"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
