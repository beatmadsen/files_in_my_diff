# frozen_string_literal: true

require 'test_helper'

module FilesInMyDiff
  module Git
    class DiffTest < Minitest::Test
      def test_it_validates_that_revision_exists
        assert_raises(ValidationError) do
          subject(object: nil).validate!
        end
      end

      def test_it_returns_the_sha_of_the_revision
        assert_equal 'x', subject.sha
      end

      def test_that_error_on_diff_calculation_is_propagated
        assert_raises(Git::DiffError) do
          subject(object: git_object_stub(diff_success: false)).changes
        end
      end

      def test_it_returns_the_changes_since_the_parent_revision
        assert_equal [{ path: 'file_1', type: :added }], subject.changes
      end

      private

      def subject(object: git_object_stub, revision: 'y')
        Diff.new(object:, revision:)
      end

      def git_object_stub(diff_success: true)
        GitObjectStub.new(diff_success)
      end

      class GitObjectStub
        def initialize(diff_success)
          @diff_success = diff_success
        end

        def sha = 'x'

        def diff_parent
          @diff_success ? [Change.new('file_1', :added)] : raise(Git::DiffError)
        end
      end

      class Change
        attr_reader :path, :type

        def initialize(path, type)
          @path = path
          @type = type
        end
      end
    end
  end
end
