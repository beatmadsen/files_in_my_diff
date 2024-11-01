# frozen_string_literal: true

require_relative 'files_in_my_diff/version'

module FilesInMyDiff
  def self.root
    File.expand_path('..', __dir__)
  end

  class Error < StandardError; end
  # Your code goes here...
end
