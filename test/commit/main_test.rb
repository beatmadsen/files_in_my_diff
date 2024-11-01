# frozen_string_literal: true

require 'test_helper'

module FilesInMyDiff
  module Commit
    class MainTest < Minitest::Test
      def test_that_main_validates_folder
        assert_raises(ArgumentError) { subject(folder: nil).call }
      end

      def test_that_main_validates_folder_exists
        assert_raises(ArgumentError) do
          file_strategy = file_strategy_stub(dir_exist: false)
          subject(file_strategy:).call
        end
      end

      private

      def subject(folder: 'x', revision: 'HEAD', file_strategy: file_strategy_stub)
        Main.new(folder:, revision:, file_strategy:)
      end

      def file_strategy_stub(dir_exist: true)
        FileStrategyStub.new(dir_exist)
      end

      class FileStrategyStub
        def initialize(dir_exist)
          @dir_exist = dir_exist
        end

        def dir_exist?(_folder)
          @dir_exist
        end
      end
    end
  end
end
