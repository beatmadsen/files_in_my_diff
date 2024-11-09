# frozen_string_literal: true

require 'test_helper'

module FilesInMyDiff
  class ResolverTest < Minitest::Test
    def test_that_main_validates_folder
      assert_raises(ValidationError) { subject(folder: nil).call }
    end

    def test_that_main_validates_folder_exists
      file_strategy = file_strategy_stub(dir_exists: false)
      assert_raises(ValidationError) do
        subject(file_strategy:).call
      end
    end

    def test_that_main_validates_that_revision_exists
      git_strategy = git_strategy_stub(revision_exists: false)
      assert_raises(ValidationError) do
        subject(git_strategy:).call
      end
    end

    def test_that_error_on_tmp_dir_resolution_is_propagated
      file_strategy = file_strategy_stub(create_success: false)
      assert_raises(TmpDir::DirectoryError) do
        subject(file_strategy:).call
      end
    end

    def test_that_error_on_diff_calculation_is_propagated
      git_strategy = git_strategy_stub(diff_success: false)
      assert_raises(Git::DiffError) do
        subject(git_strategy:).call
      end
    end

    def test_that_error_on_checkout_is_propagated
      git_strategy = git_strategy_stub(checkout_success: false)
      assert_raises(Git::CheckoutError) do
        subject(git_strategy:).call
      end
    end

    def test_that_error_on_locating_files_is_propagated
      file_strategy = file_strategy_stub(decorate_success: false)
      assert_raises(TmpDir::FileError) do
        subject(file_strategy:).call
      end
    end

    def test_that_main_returns_dir_and_sha_and_changes
      result = subject.call

      refute_empty result
    end

    private

    def subject(folder: 'x', revision: 'HEAD', file_strategy: file_strategy_stub, git_strategy: git_strategy_stub)
      Resolver.new(folder:, revision:, file_strategy:, git_strategy:)
    end

    def file_strategy_stub(dir_exists: true, create_success: true, decorate_success: true)
      FileStrategyStub.new(dir_exists, create_success, decorate_success)
    end

    def git_strategy_stub(revision_exists: true, diff_success: true, checkout_success: true)
      GitStrategyStub.new(revision_exists, diff_success, checkout_success)
    end

    class FileStrategyStub
      def initialize(dir_exists, create_success, decorate_success)
        @dir_exists = dir_exists
        @create_success = create_success
        @decorate_success = decorate_success
      end

      def dir_exists?(_folder)
        @dir_exists
      end

      def revision_dir(_sha)
        return BadCreateRevisionDirStub unless @create_success
        return BadDecorateRevisionDirStub unless @decorate_success

        ValidRevisionDirStub
      end
    end

    module BadCreateRevisionDirStub
      def self.create!
        raise TmpDir::DirectoryError
      end
    end

    module BadDecorateRevisionDirStub
      class << self
        def dir = 'lalalala'
        def create! = true

        def decorate(_changes)
          raise TmpDir::FileError
        end
      end
    end

    module ValidRevisionDirStub
      class << self
        def dir = 'lalalala'
        def create! = true
        def decorate(_changes) = { test: true }
      end
    end

    class GitStrategyStub
      def initialize(revision_exists, diff_success, checkout_success)
        @revision_exists = revision_exists
        @diff_success = diff_success
        @checkout_success = checkout_success
      end

      def diff(_revision)
        return InvalidDiffStub unless @revision_exists
        raise Git::DiffError unless @diff_success

        ValidDiffStub
      end

      def checkout_worktree(_dir, _sha)
        raise Git::CheckoutError unless @checkout_success
      end
    end

    module InvalidDiffStub
      def self.validate!
        raise ValidationError
      end
    end

    module ValidDiffStub
      class << self
        def validate! = true
        def sha = 'abcd1234'
        def changes = []
      end
    end
  end
end
