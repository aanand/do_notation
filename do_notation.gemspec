Gem::Specification.new do |s|
  s.name = "do_notation"
  s.version = "0.2.0"
  s.summary = 'Haskell-style monad do-notation for Ruby'
  s.email = 'aanand.prasad@gmail.com'
  s.homepage = 'https://github.com/aanand/do_notation'
  s.authors = ["Aanand Prasad"]

  s.extra_rdoc_files = ["README.rdoc"]
  s.files = `git ls-files`.split
  s.require_paths = ["lib"]

  s.add_dependency('ParseTree')
  s.add_dependency('ruby2ruby', '1.1.9')
  s.add_development_dependency('rake')
  s.add_development_dependency('rspec', '~> 2.0')
end
