# frozen_string_literal: true

require 'fileutils'

require_relative 'files_in_my_diff/errors'
require_relative 'files_in_my_diff/version'
require_relative 'files_in_my_diff/tmp_dir'
require_relative 'files_in_my_diff/git'
require_relative 'files_in_my_diff/resolver'

module FilesInMyDiff
  def self.root
    File.expand_path('..', __dir__)
  end

  def self.checkout(folder:, revision:)
    Resolver.new(folder:, revision:).call
  end
end
