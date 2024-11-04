# frozen_string_literal: true

module FilesInMyDiff
  module TmpDir
    class DirectoryError < FilesInMyDiff::Error; end
    class FileError < FilesInMyDiff::Error; end

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

      def self.create_tmp_dir(sha)
        path = File.join(Dir.tmpdir, 'files_in_my_diff', sha)
        FileUtils.mkdir_p(path)
        path
      rescue StandardError => e
        raise DirectoryError, "Failed to create tmp dir for #{sha}: #{e.message}"
      end

      def self.locate_files(_dir, changes)
        # TODO
        changes
      end
    end

    class RevisionDir
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

        # TODO
        decorated = changes
        { dir: @dir, sha: @sha, changes: decorated }
      end
    end
  end
end
