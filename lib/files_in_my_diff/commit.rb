# frozen_string_literal: true

module FilesInMyDiff
  module Commit
    class Main
      def initialize(folder:, revision:, file_strategy: TmpDir::FileStrategy, git_strategy: Git::Adapter.new(folder:))
        @folder = folder
        @revision = revision
        @file_strategy = file_strategy
        @git_strategy = git_strategy
      end

      def call
        validate_folder!
        validate_revision!
        sha = @git_strategy.object.sha
        dir = @file_strategy.create_tmp_dir(sha)
        @git_strategy.diff
        { dir:, sha: }
      end

      private

      def validate_folder!
        raise ValidationError, 'Folder is required' if @folder.nil?
        raise ValidationError, 'Folder does not exist' unless @file_strategy.dir_exists?(@folder)
      end

      def validate_revision!
        raise ValidationError, 'Revision is required' if @revision.nil?
        raise ValidationError, 'Revision does not exist' unless @git_strategy.revision_exists?(@revision)
      end
    end
  end
end
