# frozen_string_literal: true

# The gem this wraps. Nothing else requires it, so a caller doing only
# `require 'files_in_my_diff'` would otherwise get an uninitialized constant.
require 'git'

require_relative 'git/adapter'
require_relative 'git/diff'

module FilesInMyDiff
  module Git
    class DiffError < Error; end
    class CheckoutError < Error; end
  end
end
