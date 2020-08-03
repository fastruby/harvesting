
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "harvesting/version"

Gem::Specification.new do |spec|
  spec.name          = "harvesting"
  spec.version       = Harvesting::VERSION
  spec.authors       = ["Ernesto Tagwerker", "M. Scott Ford"]
  spec.email         = ["ernesto+github@ombulabs.com", "scott@mscottford.com"]

  spec.summary       = %q{Ruby wrapper for the Harvest API v2.0}
  spec.description   = %q{Interact with the Harvest API v2.0 from your Ruby application}
  spec.homepage      = "https://github.com/fastruby/harvesting"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|fixtures|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_dependency "http", "~> 3.3", ">= 3.3"

  spec.add_development_dependency "bundler", ">= 2.0", "< 3.0"
  spec.add_development_dependency "generator_spec", "~> 0.9.4"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "guard-rspec", "~> 4.7", ">= 4.7"
  spec.add_development_dependency "byebug", "~> 10.0", ">= 10.0"
  spec.add_development_dependency "vcr", "~> 4.0", ">= 4.0"
  spec.add_development_dependency "webmock", "~> 3.4", ">= 3.4"
  spec.add_development_dependency "dotenv", "~> 2.5", ">= 2.5"
end
