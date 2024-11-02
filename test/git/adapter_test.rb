# frozen_string_literal: true

require 'test_helper'

module FilesInMyDiff
  module Git
    class AdapterTest < Minitest::Test
      def test_it_returns_a_diff_instance
        assert_instance_of Diff, subject.diff('x')
      end

      def test_that_diff_is_evaluated_by_sha_for_git_objects
        mock = GitRepoMock.new
        sha = 'y'
        subject(repo: mock).diff(GitObjectStub.new(sha:))

        assert_equal mock.object_called_with, sha
      end

      def test_that_diff_is_evaluated_by_revision_for_strings
        mock = GitRepoMock.new
        revision = 'HEAD~1'
        subject(repo: mock).diff(revision)

        assert_equal mock.object_called_with, revision
      end

      private

      def subject(repo: GitRepoStub.new)
        Adapter.new(repo:, folder: 'x')
      end

      class GitObjectStub < ::Git::Object::AbstractObject
        attr_reader :sha

        def initialize(sha: nil)
          super(nil, nil)
          @sha = sha
        end
      end

      class GitRepoMock
        attr_reader :object_called_with

        def object(revision)
          @object_called_with = revision
          GitObjectStub.new
        end
      end

      class GitRepoStub
        def object(_revision)
          GitObjectStub.new
        end
      end
    end
  end
end
