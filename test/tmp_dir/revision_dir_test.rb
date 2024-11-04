# frozen_string_literal: true

require 'test_helper'

module FilesInMyDiff
  module TmpDir
    class RevisionDirTest < Minitest::Test
      def test_that_error_locating_tmp_dir_is_propagated
        file_strategy = file_strategy_stub(tmpdir_success: false)
        subject = subject(file_strategy:)
        assert_raises(TmpDir::DirectoryError) { subject.create! }
      end

      def test_that_creating_dir_is_propagated
        file_strategy = file_strategy_stub(mkdir_success: false)
        subject = subject(file_strategy:)
        assert_raises(TmpDir::DirectoryError) { subject.create! }
      end

      def test_that_create_does_not_return_a_value
        assert_nil subject.create!
      end

      def test_that_decorating_fails_if_dir_not_created
        file_strategy = file_strategy_stub(mkdir_success: false)
        subject = subject(file_strategy:)
        assert_raises(TmpDir::DirectoryError) { subject.decorate([]) }
      end

      private

      def subject(sha: 'ab12cd34', file_strategy: file_strategy_stub)
        RevisionDir.new(sha:, file_strategy:)
      end

      def file_strategy_stub(tmpdir_success: true, mkdir_success: true)
        FileStrategyStub.new(tmpdir_success:, mkdir_success:)
      end

      class FileStrategyStub
        def initialize(tmpdir_success:, mkdir_success:)
          @tmpdir_success = tmpdir_success
          @mkdir_success = mkdir_success
        end

        def tmpdir
          raise TmpDir::DirectoryError unless @tmpdir_success

          'some_tmpdir'
        end

        def mkdir_p(_path)
          raise TmpDir::DirectoryError unless @mkdir_success
        end
      end
    end
  end
end
