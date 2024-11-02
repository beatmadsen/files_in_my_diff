# frozen_string_literal: true

require 'test_helper'

class IntegrationTest < Minitest::Test
  def test_that_main_interface_returns_non_empty_result_for_valid_input
    changes = FilesInMyDiff.checkout(folder: GIT_PROJECT_PATH, revision: 'HEAD')

    refute_nil changes
    refute_empty changes
  end
end
