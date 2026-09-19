# frozen_string_literal: true

require 'test_helper'
require 'open3'

# The tool is pointed at other people's repositories, and those have bundles of
# their own that do not list this gem. The shipped executable has to load from
# the gems installed around it rather than from whatever bundle is ambient.
class ExecutableTest < Minitest::Test
  EXECUTABLE = File.expand_path('../bin/files_in_my_diff', __dir__)

  def test_runs_when_the_ambient_bundle_does_not_include_this_gem
    stdout, stderr, status = run_detached_from_the_bundle

    assert_predicate status, :success?, "expected the executable to run, got: #{stderr}"
    assert_match(/"sha"/, stdout)
  end

  private

  def run_detached_from_the_bundle
    env = {
      'BUNDLE_GEMFILE' => File.expand_path('../no/such/Gemfile', __dir__),
      'RUBYLIB' => File.expand_path('../lib', __dir__),
      'RUBYOPT' => nil, 'BUNDLER_SETUP' => nil,
      'BUNDLER_VERSION' => nil, 'BUNDLE_BIN_PATH' => nil,
    }
    Open3.capture3(env, RbConfig.ruby, EXECUTABLE, GIT_PROJECT_PATH, 'HEAD')
  end
end
