
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "retrodb/version"

Gem::Specification.new do |spec|
  spec.name          = "retrodb"
  spec.version       = Retrodb::VERSION
  spec.authors       = ["Jason Knabl"]
  spec.email         = ["jason.knabl@gmail.com"]

  spec.summary       = %q{Convert retrosheet event files to a database with relative ease.}
  spec.description   = %q{Convert retrosheet event files to a database with relative ease.}
  spec.homepage      = "http:/www.github.com/jknabl"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
    spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rb-readline'
  spec.add_development_dependency 'vcr'
  spec.add_dependency "activerecord"
  spec.add_dependency 'activerecord-import'
  spec.add_dependency "standalone_migrations"
  spec.add_dependency 'postgresql'
  spec.add_dependency "http"
  spec.add_dependency "rubyzip"
  spec.add_dependency "zlib"
  spec.add_dependency "thread"
  spec.add_dependency "nokogiri"
end
