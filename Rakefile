# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'minitest/test_task'

Minitest::TestTask.create

require 'rubocop/rake_task'

RuboCop::RakeTask.new

# Plain rubocop, not rubocop:autocorrect. A gate that rewrites the code it is
# judging reports success by editing the working tree, which is not a verdict.
task default: %i[test rubocop]
