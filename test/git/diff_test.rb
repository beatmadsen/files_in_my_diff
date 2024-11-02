# frozen_string_literal: true

require 'test_helper'

module FilesInMyDiff
  module Git
    class DiffTest < Minitest::Test
      def test_it_validates_that_revision_exists
        assert_raises(ValidationError) do
          adapter = adapter_stub(revision_exists: false)
          subject(adapter:).validate!
        end
      end

      private

      def subject(adapter: adapter_stub)
        Diff.new(folder: 'x', revision: 'y', adapter:)
      end

      def adapter_stub(revision_exists: true)
        AdapterStub.new(revision_exists)
      end

      class AdapterStub
        def initialize(revision_exists)
          @revision_exists = revision_exists
        end

        def object(_revision)
          GitObjectStub.new
        end

        def revision_exists?(_revision = nil)
          @revision_exists
        end
      end

      class GitObjectStub
        def sha = 'x'
      end
    end
  end
end
