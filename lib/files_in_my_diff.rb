# frozen_string_literal: true

require_relative 'files_in_my_diff/version'

module FilesInMyDiff
  def self.root
    File.expand_path('..', __dir__)
  end

  class Error < StandardError; end

  def self.checkout(folder:, commit:)
    Main.new(folder: folder, commit: commit).call
  end

  class Main
    def initialize(folder:, commit:)
      @folder = folder
      @commit = commit
    end

    def call
      validate_folder!
      validate_commit!
      { dummy: true }
    end

    private

    def validate_folder!
      raise ArgumentError, 'Folder is required' if @folder.nil?
    end

    def validate_commit!
      raise ArgumentError, 'Commit is required' if @commit.nil?
    end
  end
end
