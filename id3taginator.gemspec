# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = 'id3taginator'
  spec.version       = '0.5'
  spec.authors       = ['Christian Feier']
  spec.email         = ['Christian.Feier@gmail.com']

  spec.summary       = 'Id3Taginator is a ID3v1, ID3v2.2/3/4 tag reader and writer fully written in Ruby and does not'\
                       'rely on TagLib or any other 3rd party library to read/write id3tags. It aims to offer a simple'\
                       'way to read and write ID3Tags.'
  spec.description   = 'Id3Taginator is a ID3v1, ID3v2.2/3/4 tag reader and writer fully written in Ruby and does not'\
                       'rely on TagLib or any other 3rd party library to read/write id3tags. It aims to offer a simple'\
                       'way to read and write ID3Tags.'
  spec.homepage      = 'https://github.com/cfe86/Id3Taginator'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 2.5.1'

  spec.metadata['homepage_uri'] = 'https://github.com/cfe86/Id3Taginator'
  spec.metadata['source_code_uri'] = 'https://github.com/cfe86/Id3Taginator'
  spec.metadata['changelog_uri'] = 'https://github.com/cfe86/Id3Taginator'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
