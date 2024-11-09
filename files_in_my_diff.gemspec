# frozen_string_literal: true

require_relative 'lib/files_in_my_diff/version'

Gem::Specification.new do |spec|
  spec.name = 'files_in_my_diff'
  spec.version = FilesInMyDiff::VERSION
  spec.authors = ['Erik T. Madsen']
  spec.email = ['beatmadsen@gmail.com']

  spec.summary = 'Checks out a git revision in a new worktree and provides you the changed files'
  spec.description = 'A command line tool that takes a git repository path and revision as input. ' \
                     'It creates a temporary worktree, checks out the specified revision, and returns ' \
                     'a JSON object containing the worktree path, commit SHA, and list of changed files. ' \
                     'The tool helps you inspect changes in any git revision without affecting your ' \
                     'current working directory.'

  spec.homepage = 'https://github.com/beatmadsen/files-in-my-diff'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.2'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/beatmadsen/files-in-my-diff'
  spec.metadata['changelog_uri'] = 'https://github.com/beatmadsen/files-in-my-diff/blob/main/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = 'bin'
  spec.executables = ['files_in_my_diff']
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  spec.add_dependency 'git', '~> 2.3'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata['rubygems_mfa_required'] = 'true'
end
