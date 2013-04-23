Gem::Specification.new do |spec|
  spec.name		= "pivotal-brancher"
  spec.version		= "0.0.2"
  author_list = {
    "Judson Lester" => 'nyarly@gmail.com'
  }
  spec.authors		= author_list.keys
  spec.email		= spec.authors.map {|name| author_list[name]}
  spec.summary		= "Quickly switch to a feature branch for your current story"
  spec.description	= <<-EndDescription
  Some command line tools to be used in tandem with a githook for Pivotal

  `pb start` will switch to (possibly creating) a git branch named for your
  current highest priority started Pivotal story.
  EndDescription

  spec.rubyforge_project= spec.name.downcase
  spec.homepage        = "http://nyarly.github.com/#{spec.name.downcase}"
  spec.required_rubygems_version = Gem::Requirement.new(">= 0") if spec.respond_to? :required_rubygems_version=

  # Do this: y$@"
  # !!find lib bin doc spec spec_help -not -regex '.*\.sw.' -type f 2>/dev/null
  spec.files		= %w[
    lib/pivotal-brancher/app.rb
    lib/pivotal-brancher/cli.rb
    lib/pivotal-brancher.rb
    bin/pb
    spec/start.rb
    spec_support/all.rb
    spec_support/capture.rb
  ]

  #spec.test_file        = "spec_help/gem_test_suite.rb"
  spec.licenses = ["MIT"]
  spec.require_paths = %w[lib/]
  spec.rubygems_version = "1.3.5"

  spec.executables = %w{ pb }

  spec.has_rdoc		= true
  spec.extra_rdoc_files = Dir.glob("doc/**/*")
  spec.rdoc_options	= %w{--inline-source }
  spec.rdoc_options	+= %w{--main doc/README }
  spec.rdoc_options	+= ["--title", "#{spec.name}-#{spec.version} Documentation"]

  spec.add_dependency("pivotal-tracker", "~> 0.5.1")
  spec.add_dependency("valise", "~> 0.9")
  spec.add_dependency("thor", "~> 0.18")

  #spec.post_install_message = "Thanks for installing my gem!"
end
