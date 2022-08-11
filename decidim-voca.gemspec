# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)
require "decidim/voca/version"

Gem::Specification.new do |s|
  s.version = Decidim::Voca.version
  s.authors = ["Renato", "Hadrien"]
  s.email = ["renato@octree.ch", "hadrien@octree.ch"]
  s.license = "AGPL-3.0"
  s.homepage = "https://git.octree.ch/decidim/vocacity/tasks"
  s.required_ruby_version = ">= 2.7"

  s.name = "decidim-voca"
  s.summary = "A decidim voca module"
  s.description = "voca."

  s.files = Dir["{app,config,lib}/**/*", "LICENSE.md", "Rakefile", "README.md"]

end
