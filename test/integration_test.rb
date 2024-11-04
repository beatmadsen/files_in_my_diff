# frozen_string_literal: true

require 'test_helper'

class IntegrationTest < Minitest::Test
  def test_that_main_interface_returns_non_empty_result_for_valid_input
    result = FilesInMyDiff.checkout(folder: GIT_PROJECT_PATH, revision: 'HEAD')
    result => { dir:, sha:, changes: }

    refute_nil dir
    refute_nil sha
    has_correct_changes = changes&.any? && changes.all? do |change|
      fp = change[:full_path]
      !fp.nil? && !fp.empty? && fp.start_with?(dir) && fp.include?(sha)
    end

    assert has_correct_changes, "Changes are not valid: #{changes.inspect}"
  end
end
