# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rdbacl}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["David Richards"]
  s.date = %q{2009-02-14}
  s.description = %q{Ruby interface for dbacl.}
  s.email = %q{davidlamontrichards@gmail.com}
  s.extra_rdoc_files = ["lib/rdbacl.rb", "README.rdoc"]
  s.files = ["init.rb", "lib/rdbacl.rb", "Manifest", "Rakefile", "README.rdoc", "spec/spec_helper.rb", "rdbacl.gemspec"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/davidrichards/rdbacl}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Rdbacl", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{rdbacl}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Ruby interface for dbacl.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
