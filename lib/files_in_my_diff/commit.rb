# frozen_string_literal: true

module FilesInMyDiff
  module Commit
    class Main
      def initialize(folder:, revision:, factory: Factory)
        @folder = folder
        @revision = revision
        @factory = factory
      end

      def call
        validate_folder!
        validate_revision!
        { dummy: true }
      end

      private

      def validate_folder!
        raise ArgumentError, 'Folder is required' if @folder.nil?
        raise ArgumentError, 'Folder does not exist' unless factory.file_strategy.dir_exist?(@folder)
      end

      def validate_revision!
        raise ArgumentError, 'Revision is required' if @revision.nil?
      end
    end
  end
end
