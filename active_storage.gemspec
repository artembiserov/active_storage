$LOAD_PATH.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "active_storage/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "active_storage"
  s.version     = ActiveStorage::VERSION
  s.authors     = ["Artem Biserov"]
  s.email       = ["artem.biserov@gmail.com"]
  s.homepage    = "http://github.com/artembiserov/active_storage"
  s.summary     = "Simple storage implementation."
  s.description = "Storage records on filesystem."
  s.license     = "MIT"

  # s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.add_runtime_dependency "activesupport"
end
