# frozen_string_literal: true

require 'test_helper'

class FilesInMyDiffTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::FilesInMyDiff::VERSION
  end

  def test_that_main_validates_folder
    assert_raises(ArgumentError) { FilesInMyDiff::Main.new(folder: nil, commit: 'HEAD').call }
  end
end
