# frozen_string_literal: true

module FilesInMyDiff
  module TmpDir
    class DirectoryError < FilesInMyDiff::Error; end

    module FileStrategy
      def self.dir_exists?(folder)
        Dir.exist?(folder)
      end

      def self.create_tmp_dir(sha)
        path = File.join(Dir.tmpdir, 'files_in_my_diff', sha)
        FileUtils.mkdir_p(path)
        path
      rescue StandardError => e
        raise DirectoryError, "Failed to create tmp dir for #{sha}: #{e.message}"
      end
    end
  end
end
