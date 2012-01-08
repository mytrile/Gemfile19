Gem::Specification.new do |s|
  s.name        = "gemfile19"
  s.version     = "1.0.1"
  s.description = "Simple command line tool for checking gems in your Gemfile for Ruby 1.9 compatability"
  s.homepage    = "https://github.com/mytrile/gemfile19"
  s.summary     = s.description

  s.authors = [
    "Mitko Kostov"
  ]

  s.email = [
    "mitko.kostov@gmail.com"
  ]

  s.files = [
    "README.md",
    "lib/gemfile19.rb",
    "bin/gemfile19"
  ]

  s.executables = "gemfile19"

  s.add_dependency "json", "~> 1.6.1"
  s.add_dependency "term-ansicolor", "~> 1.0.7"
end
