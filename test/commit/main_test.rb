# frozen_string_literal: true

require 'test_helper'

module FilesInMyDiff
  module Commit
    class MainTest < Minitest::Test
      def test_that_main_validates_folder
        assert_raises(ArgumentError) { Main.new(folder: nil, revision: 'HEAD').call }
      end

      def test_that_main_validates_folder_exists
        assert_raises(ArgumentError) { Main.new(folder: 'non-existent-folder', revision: 'HEAD').call }
      end
    end
  end
end
