Gem::Specification.new do |s|
  s.name = 'dx_sliml'
  s.version = '0.1.3'
  s.summary = 'Uses a Sliml like format to transform a Dynarex document to HTML.'
  s.authors = ['James Robertson']
  s.files = Dir['lib/dx_sliml.rb']
  s.add_runtime_dependency('dynarex', '~> 1.5', '>=1.5.34')
  s.signing_key = '../privatekeys/dx_sliml.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@r0bertson.co.uk'
  s.homepage = 'https://github.com/jrobertson/dx_sliml'
end
