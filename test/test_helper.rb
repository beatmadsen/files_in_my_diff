# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'files_in_my_diff'

require 'minitest/autorun'

require 'active_support'
require 'active_support/testing/parallelization'
require 'active_support/testing/parallelize_executor'
require 'concurrent/utility/processor_counter'

Minitest.parallel_executor = ActiveSupport::Testing::ParallelizeExecutor.new(
  size: Concurrent.processor_count,
  with: :processes,
  threshold: 0,
)

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
  if GIT_PROJECT_PATH && Dir.exist?(GIT_PROJECT_PATH)
    FileUtils.rm_rf(GIT_PROJECT_PATH)
  end
end

# Tear down the dummy Git project after all tests have run
Minitest.after_run { teardown_dummy_git_project }

# Run setup before all tests
setup_dummy_git_project
