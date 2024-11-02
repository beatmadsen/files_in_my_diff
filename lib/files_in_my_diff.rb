# frozen_string_literal: true

require 'git'
require 'tmpdir'
require 'fileutils'

module FilesInMyDiff
  class Error < StandardError; end
  class ValidationError < Error; end
end

require_relative 'files_in_my_diff/version'
require_relative 'files_in_my_diff/commit'
require_relative 'files_in_my_diff/git'

module FilesInMyDiff
  def self.root
    File.expand_path('..', __dir__)
  end

  def self.checkout(folder:, revision:)
    Commit::Main.new(folder:, revision:).call
  end
end
