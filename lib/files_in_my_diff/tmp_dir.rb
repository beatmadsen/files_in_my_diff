# frozen_string_literal: true

require_relative 'tmp_dir/revision_dir'
require_relative 'tmp_dir/file_strategy'

module FilesInMyDiff
  module TmpDir
    class DirectoryError < FilesInMyDiff::Error; end
    class FileError < FilesInMyDiff::Error; end
  end
end
