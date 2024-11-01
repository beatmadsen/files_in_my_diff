# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'files_in_my_diff'

require 'minitest/autorun'

require 'active_support'
require 'active_support/testing/parallelization'
require 'active_support/testing/parallelize_executor'
require 'concurrent/utility/processor_counter'

Minitest.parallel_executor = ActiveSupport::Testing::ParallelizeExecutor.new(
  size: Concurrent.processor_count,
  with: :processes,
  threshold: 0,
)