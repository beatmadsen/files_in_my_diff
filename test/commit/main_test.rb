# frozen_string_literal: true

require 'test_helper'

module FilesInMyDiff
  module Commit
    class MainTest < Minitest::Test
      def test_that_main_validates_folder
        assert_raises(ValidationError) { subject(folder: nil).call }
      end

      def test_that_main_validates_folder_exists
        assert_raises(ValidationError) do
          file_strategy = file_strategy_stub(dir_exists: false)
          subject(file_strategy:).call
        end
      end

      def test_that_main_validates_revision_as_a_real_git_object
        assert_raises(ValidationError) do
          git_strategy = git_strategy_stub(revision_exists: false)
          subject(git_strategy:).call
        end
      end

      private

      def subject(folder: 'x', revision: 'HEAD', file_strategy: file_strategy_stub, git_strategy: git_strategy_stub)
        Main.new(folder:, revision:, file_strategy:, git_strategy:)
      end

      def file_strategy_stub(dir_exists: true)
        FileStrategyStub.new(dir_exists)
      end

      def git_strategy_stub(revision_exists: true)
        GitStrategyStub.new(revision_exists)
      end

      class FileStrategyStub
        def initialize(dir_exists)
          @dir_exists = dir_exists
        end

        def dir_exists?(_folder)
          @dir_exists
        end
      end

      class GitStrategyStub
        def initialize(revision_exists)
          @revision_exists = revision_exists
        end

        def revision_exists?(_revision)
          @revision_exists
        end
      end
    end
  end
end
