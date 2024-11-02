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
