$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'kit/payment/version'

version = Kit::Payment::VERSION

Gem::Specification.new do |s|
  s.name        = 'kit-payment'
  s.version     = version
  s.summary     = 'Everything you need to collect & track money.'
  s.description = ''
  s.license     = 'MIT'
  s.author      = 'Nathan Appere'
  s.email       = 'nathan@rubykit.org'
  s.homepage    = 'https://github.com/rubykit/kit/tree/master/domains/kit-payment'

  s.metadata = {
    'source_code_base_uri' => 'https://github.com/rubykit/kit',
    'source_code_uri'      => "https://github.com/rubykit/kit/tree/v#{ version }/domains/kit-payment",
    'documentation_uri'    => "https://docs.rubykit.org/v#{ version }",
  }

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

end
