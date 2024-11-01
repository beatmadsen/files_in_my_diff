# frozen_string_literal: true

require 'git'
require 'fileutils'
require 'tmpdir'

GIT_PROJECT_PATH = Dir.mktmpdir

# Set up a dummy Git project before running tests
def setup_dummy_git_project
  repo = Git.init(GIT_PROJECT_PATH)

  ['first.rb', 'second.rb', 'third.rb'].each do |file_name|
    source_file = File.join(FilesInMyDiff.root, 'test', 'support', file_name)
    dest_file = File.join(GIT_PROJECT_PATH, file_name)
    FileUtils.cp(source_file, dest_file)
    repo.add(file_name)
    repo.commit("Add #{file_name}")
  end
end

def teardown_dummy_git_project
  return unless GIT_PROJECT_PATH && Dir.exist?(GIT_PROJECT_PATH)

  FileUtils.rm_rf(GIT_PROJECT_PATH)
end

# Tear down the dummy Git project after all tests have run
Minitest.after_run { teardown_dummy_git_project }

# Run setup before all tests
setup_dummy_git_project
