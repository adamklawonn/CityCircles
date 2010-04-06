# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{netrecorder}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Chris Young"]
  s.date = %q{2010-01-24}
  s.description = %q{Record network responses for easy stubbing of external calls}
  s.email = %q{beesucker@gmail.com}
  s.extra_rdoc_files = ["README.rdoc", "lib/config.rb", "lib/http.rb", "lib/http_header.rb", "lib/netrecorder.rb"]
  s.files = ["Manifest", "README.rdoc", "Rakefile", "features/manage_cache.feature", "features/step_definitions/manage_cache_steps.rb", "features/support/env.rb", "lib/config.rb", "lib/http.rb", "lib/http_header.rb", "lib/netrecorder.rb", "netrecorder.gemspec"]
  s.homepage = %q{http://github.com/chrisyoung/netrecorder}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Netrecorder", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{netrecorder}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Record network responses for easy stubbing of external calls}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<fakeweb>, [">= 0"])
      s.add_development_dependency(%q<echoe>, [">= 0"])
      s.add_development_dependency(%q<cucumber>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
    else
      s.add_dependency(%q<fakeweb>, [">= 0"])
      s.add_dependency(%q<echoe>, [">= 0"])
      s.add_dependency(%q<cucumber>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
    end
  else
    s.add_dependency(%q<fakeweb>, [">= 0"])
    s.add_dependency(%q<echoe>, [">= 0"])
    s.add_dependency(%q<cucumber>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
  end
end
