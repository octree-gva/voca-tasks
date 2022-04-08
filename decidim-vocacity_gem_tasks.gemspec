# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require_relative "lib/decidim/vocacity_gem_tasks/version"
Gem::Specification.new do |s|
  s.version = Decidim::VocacityGemTasks.version
  s.authors = [""]
  s.email = ["renato@octree.ch", "hadrien@octree.ch"]
  s.license = "AGPL-3.0"
  s.homepage = "https://git.octree.ch/decidim/vocacity/tasks"
  s.required_ruby_version = ">= 2.7"

  s.name = "decidim-vocacity_gem_tasks"
  s.summary = "A decidim vocacity_gem_tasks module"
  s.description = "vocacity_gem_tasks."

  s.files = Dir["{app,config,lib}/**/*", "LICENSE-AGPLv3.txt", "Rakefile", "README.md"]
  s.require_paths = ["lib"]
  s.add_dependency "decidim", Decidim::VocacityGemTasks.version
  s.add_dependency "aws-sdk-s3", "~> 1"
  s.add_dependency "rails"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rspec_junit_formatter"
  s.add_development_dependency "decidim-dev", Decidim::VocacityGemTasks.version
  s.add_development_dependency "decidim-consultations", Decidim::VocacityGemTasks.version
  s.add_development_dependency "decidim-participatory_processes", Decidim::VocacityGemTasks.version
  s.add_development_dependency "decidim-proposals", Decidim::VocacityGemTasks.version
  s.add_development_dependency "decidim", Decidim::VocacityGemTasks.version

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "bootsnap"
  s.add_development_dependency "puma"
  s.add_development_dependency "uglifier"
  s.add_development_dependency "codecov"

end
