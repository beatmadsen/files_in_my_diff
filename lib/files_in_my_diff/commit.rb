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
        diff = @git_strategy.diff(@revision)
        diff.validate!
        rd = @file_strategy.revision_dir(diff.sha)
        rd.create!
        @git_strategy.checkout_worktree(rd.dir, diff.sha)
        rd.decorate(diff.changes)
      end

      private

      def validate_folder!
        raise ValidationError, 'Folder is required' if @folder.nil?
        raise ValidationError, 'Folder does not exist' unless @file_strategy.dir_exists?(@folder)
      end
    end
  end
end
