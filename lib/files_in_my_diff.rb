# frozen_string_literal: true

require_relative 'files_in_my_diff/version'
require_relative 'files_in_my_diff/commit'

module FilesInMyDiff
  def self.root
    File.expand_path('..', __dir__)
  end

  class Error < StandardError; end

  def self.checkout(folder:, revision:)
    Commit::Main.new(folder:, revision:).call
  end
end
