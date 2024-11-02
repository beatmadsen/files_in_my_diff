# frozen_string_literal: true

require_relative 'git/adapter'
require_relative 'git/diff'

module FilesInMyDiff
  module Git
    class DiffError < Error; end
    class CheckoutError < Error; end
  end
end
