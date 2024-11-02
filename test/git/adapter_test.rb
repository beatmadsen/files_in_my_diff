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

      def test_that_checkout_failure_is_propagated
        subject = subject(repo: repo_stub(checkout_success: false))
        assert_raises(Git::CheckoutError) do
          subject.checkout_worktree('x', 'y')
        end
      end

      def test_that_checkout_failure_is_recovered_if_worktree_already_exists
        subject = subject(repo: repo_stub(checkout_success: MyFailedError.new('blabla already exists blabla')))
        subject.checkout_worktree('x', 'y')
      end

      private

      def subject(repo: repo_stub)
        Adapter.new(repo:, folder: 'x')
      end

      def repo_stub(checkout_success: true)
        GitRepoStub.new(checkout_success)
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
        def initialize(checkout_success)
          @checkout_success = checkout_success
        end

        def add_worktree(_path, _revision)
          raise @checkout_success if @checkout_success.is_a?(::Git::FailedError)
          raise MyFailedError unless @checkout_success
        end

        def object(_revision)
          GitObjectStub.new
        end
      end

      class MyFailedError < ::Git::FailedError
        def initialize(stderr = 'dummy')
          super(Command.new(stderr))
        end

        class Command
          attr_reader :stderr

          def initialize(stderr)
            @stderr = stderr
          end

          def git_cmd = 'dummy'
          def status = 'dummy'
        end
      end
    end
  end
end
