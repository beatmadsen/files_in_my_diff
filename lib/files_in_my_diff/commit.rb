# frozen_string_literal: true

module FilesInMyDiff
  module Commit
    class Main
      def initialize(folder:, revision:, file_strategy: FileStrategy, git_strategy: GitStrategy.new(folder:))
        @folder = folder
        @revision = revision
        @file_strategy = file_strategy
        @git_strategy = git_strategy
      end

      def call
        validate_folder!
        validate_revision!
        { dummy: true }
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

    module FileStrategy
      def self.dir_exists?(folder)
        Dir.exist?(folder)
      end
    end

    class GitStrategy
      def initialize(folder:, repo: Git.open(folder))
        @repo = repo
      end

      def revision_exists?(revision)
        if revision.is_a?(Git::Object::AbstractObject)
          @repo.object(revision.sha) && true
        else
          @repo.object(revision) && true
        end
      rescue Git::FailedError
        false
      end
    end
  end
end
