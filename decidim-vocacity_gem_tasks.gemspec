# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

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

  s.files = Dir["{app,config,lib}/**/*.{rb,yml,rake}", "LICENSE-AGPLv3.txt", "Rakefile", "README.md"]
  s.require_paths = ["lib"]
  s.add_dependency "decidim-core", Decidim::VocacityGemTasks.version
  s.add_development_dependency "rspec"
  s.add_development_dependency "decidim-dev", Decidim::VocacityGemTasks.version
end
