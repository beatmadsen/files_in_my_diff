# frozen_string_literal: true

module FilesInMyDiff
  module TmpDir
    class RevisionDir
      attr_reader :dir

      def initialize(sha:, file_strategy: FileStrategy)
        @sha = sha
        @file_strategy = file_strategy
      end

      def create!
        tmpdir = @file_strategy.tmpdir
        @dir = File.join(tmpdir, 'files_in_my_diff', @sha)
        @file_strategy.mkdir_p(@dir)
      end

      def decorate(changes)
        raise DirectoryError, "Directory for #{@sha} not yet created" if @dir.nil?

        d_changes = changes.map do |change|
          change => { path:, type: }
          { full_path: full_path(path), relative_path: path, type: }
        end
        { dir: @dir, sha: @sha, changes: d_changes }
      end

      private

      def full_path(relative_path)
        File.join(@dir, relative_path)
      rescue StandardError => e
        raise FileError, "Failed to create full path for #{relative_path}: #{e.message}"
      end
    end
  end
end
