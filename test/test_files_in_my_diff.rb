# frozen_string_literal: true

require 'test_helper'

class TestFilesInMyDiff < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::FilesInMyDiff::VERSION
  end

  def test_temporary_to_allow_parallel_execution
    assert true
  end
end
