# frozen_string_literal: true

module FilesInMyDiff
  module Git
    class Adapter
      def initialize(folder:, repo: ::Git.open(folder))
        @repo = repo
      end

      def diff(revision)
        Diff.new(object: object(revision), revision:)
      end

      def checkout_worktree(path, revision)
        @repo.add_worktree(path, revision)
      rescue ::Git::FailedError => e
        raise CheckoutError, "Could not checkout #{revision} to #{path}: #{e.message}"
      end

      private

      def object(revision)
        if revision.is_a?(::Git::Object::AbstractObject)
          @repo.object(revision.sha)
        else
          @repo.object(revision)
        end
      rescue ::Git::FailedError
        nil
      end
    end
  end
end
