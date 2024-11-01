# frozen_string_literal: true

module FilesInMyDiff
  module Commit
    class Main
      def initialize(folder:, revision:, file_strategy: FileStrategy)
        @folder = folder
        @revision = revision
        @file_strategy = file_strategy
      end

      def call
        validate_folder!
        validate_revision!
        { dummy: true }
      end

      private

      def validate_folder!
        raise ArgumentError, 'Folder is required' if @folder.nil?
        raise ArgumentError, 'Folder does not exist' unless @file_strategy.dir_exist?(@folder)
      end

      def validate_revision!
        raise ArgumentError, 'Revision is required' if @revision.nil?
      end
    end

    module FileStrategy
      def self.dir_exist?(folder)
        Dir.exist?(folder)
      end
    end
  end
end
