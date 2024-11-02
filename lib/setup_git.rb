# frozen_string_literal: true

require 'git'

module Git
  class Base
    def add_worktree(path, revision)
      lib.send(:command, 'worktree', 'add', path, revision)
    end
  end
end
