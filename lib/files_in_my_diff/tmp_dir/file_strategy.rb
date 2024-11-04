# frozen_string_literal: true

module FilesInMyDiff
  module TmpDir
    module FileStrategy
      def self.dir_exists?(folder)
        Dir.exist?(folder)
      end

      def self.tmpdir
        Dir.tmpdir
      rescue StandardError => e
        raise DirectoryError, "Failed to locate tmpdir: #{e.message}"
      end

      def self.mkdir_p(path)
        FileUtils.mkdir_p(path)
      rescue SystemCallError => e
        raise DirectoryError, "Failed to create tmp dir for #{path}: #{e.message}"
      end

      def self.revision_dir(sha)
        RevisionDir.new(sha:)
      end
    end
  end
end
