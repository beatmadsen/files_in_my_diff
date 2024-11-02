# frozen_string_literal: true

require 'test_helper'

module FilesInMyDiff
  module Git
    class DiffTest < Minitest::Test
      def test_it_validates_that_revision_exists
        adapter = adapter_stub(revision_exists: false)
        assert_raises(ValidationError) do
          subject(adapter:).validate!
        end
      end

      def test_it_returns_the_sha_of_the_revision
        assert_equal 'x', subject.sha
      end

      def test_that_error_on_diff_calculation_is_propagated
        adapter = adapter_stub(diff_success: false)
        assert_raises(Git::DiffError) do
          subject(adapter:).changes
        end
      end

      def test_it_returns_the_changes_since_the_parent_revision
        assert_equal [{ path: 'file_1', type: :added }], subject.changes
      end

      private

      def subject(adapter: adapter_stub)
        Diff.new(folder: 'x', revision: 'y', adapter:)
      end

      def adapter_stub(revision_exists: true, diff_success: true)
        AdapterStub.new(revision_exists, diff_success)
      end

      class AdapterStub
        def initialize(revision_exists, diff_success)
          @revision_exists = revision_exists
          @diff_success = diff_success
        end

        def object(_revision)
          @revision_exists ? GitObjectStub.new(@diff_success) : nil
        end
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

      Change = Data.define(:path, :type)
    end
  end
end
