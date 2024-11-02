# frozen_string_literal: true

module FilesInMyDiff
  module Git
    class DiffError < Error; end

    class Diff
      def initialize(folder:, revision:, adapter: Adapter.new(folder:))
        @revision = revision
        @adapter = adapter
        @object = adapter.object(@revision)
      end

      def validate!
        raise ValidationError, "Revision #{@revision} does not exist" if @object.nil?
      end
    end

    class Adapter
      def object(revision = nil)
        @object ||= if revision.is_a?(::Git::Object::AbstractObject)
                      @repo.object(revision.sha)
                    else
                      @repo.object(revision)
                    end
      rescue ::Git::FailedError
        nil
      end

      def initialize(folder:, repo: ::Git.open(folder))
        @repo = repo
      end

      def revision_exists?(revision)
        @object = object(revision)
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
