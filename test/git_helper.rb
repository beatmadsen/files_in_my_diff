# frozen_string_literal: true

require 'git'
require 'fileutils'
require 'tmpdir'

GIT_PROJECT_PATH = Dir.mktmpdir

class GitHelper
  def initialize
    @repo = Git.init(GIT_PROJECT_PATH)
  end

  def setup_dummy_git_project
    setup_fake_local_git_identity
    commit_initial_files
    modify_file('first.rb')
    add_copy_of_file('second.rb')
    add_copy_of_file('third.rb')
    delete_file('second.rb')
  end

  private

  def modify_file(file_name)
    line_to_add = "\nclass Modification; end\n"
    File.write(File.join(GIT_PROJECT_PATH, file_name), line_to_add, mode: 'a')
    @repo.add(file_name)
    @repo.commit("Modify #{file_name}")
  end

  def add_copy_of_file(file_name)
    file = File.join(GIT_PROJECT_PATH, file_name)
    base_name = file_name.sub(/\.rb$/, '')
    new_name = "#{base_name}_copy.rb"
    FileUtils.cp(file, File.join(GIT_PROJECT_PATH, new_name))
    @repo.add(new_name)
    @repo.commit("Copy #{file_name} to #{new_name}")
  end

  def delete_file(file_name)
    FileUtils.rm(File.join(GIT_PROJECT_PATH, file_name))
    @repo.add(file_name)
    @repo.commit("Delete #{file_name}")
  end

  def setup_fake_local_git_identity
    original_dir = Dir.pwd
    Dir.chdir(GIT_PROJECT_PATH)
    `git config user.email "test@example.com"`
    `git config user.name "Test User"`
    # go back to the original directory
    Dir.chdir(original_dir)
  end

  def commit_initial_files
    ['first.rb', 'second.rb', 'third.rb'].each do |file_name|
      source_file = File.join(FilesInMyDiff.root, 'test', 'support', file_name)
      dest_file = File.join(GIT_PROJECT_PATH, file_name)
      FileUtils.cp(source_file, dest_file)
      @repo.add(file_name)
      @repo.commit("Add #{file_name}")
    end
  end
end

# Set up a dummy Git project before running tests
def setup_dummy_git_project
  helper = GitHelper.new
  helper.setup_dummy_git_project
end

def teardown_dummy_git_project
  return unless GIT_PROJECT_PATH && Dir.exist?(GIT_PROJECT_PATH)

  FileUtils.rm_rf(GIT_PROJECT_PATH)
end

# Tear down the dummy Git project after all tests have run
Minitest.after_run { teardown_dummy_git_project }

# Run setup before all tests
setup_dummy_git_project
