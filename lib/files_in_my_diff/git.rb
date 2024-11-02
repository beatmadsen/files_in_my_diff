# frozen_string_literal: true

module FilesInMyDiff
  module Git
    class DiffError < Error; end

    class Adapter
      attr_reader :object

      def initialize(folder:, repo: ::Git.open(folder))
        @repo = repo
      end

      def revision_exists?(revision)
        @object = if revision.is_a?(::Git::Object::AbstractObject)
                    @repo.object(revision.sha)
                  else
                    @repo.object(revision)
                  end
        @object && true
      rescue ::Git::FailedError
        false
      end

      def diff
        @object.diff_parent.map do |change|
          { path: change.path, type: change.type }
        end
      rescue ::Git::FailedError => e
        raise DiffError, "Failed to get diff for #{@object.sha}: #{e.message}"
      end
    end
  end
end
