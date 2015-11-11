Gem::Specification.new do |s|
  s.name        = 'as_json_presentable'
  s.version     = '0.0.3'
  s.date        = '2015-10-16'
  s.summary     = "JSON presenter"
  s.description = "This is a simple implementation of the presenter pattern for JSON presentation."
  s.authors     = ["Jason Rush"]
  s.email       = 'jason@pandastrike.com'
  s.files       = ["lib/as_json_presentable.rb", "lib/as_json_presentable/presenter.rb"]
  s.homepage    = 'http://pandastrike.com/'
  s.license     = 'MIT'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'byebug'
  s.add_development_dependency 'pry'
end
