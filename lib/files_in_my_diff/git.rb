# frozen_string_literal: true

module FilesInMyDiff
  module Git
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
    end
  end
end
