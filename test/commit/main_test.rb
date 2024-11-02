# frozen_string_literal: true

require 'test_helper'

module FilesInMyDiff
  module Commit
    class MainTest < Minitest::Test
      def test_that_main_validates_folder
        assert_raises(ValidationError) { subject(folder: nil).call }
      end

      def test_that_main_validates_folder_exists
        assert_raises(ValidationError) do
          file_strategy = file_strategy_stub(dir_exists: false)
          subject(file_strategy:).call
        end
      end

      def test_that_main_validates_that_revision_exists
        assert_raises(ValidationError) do
          git_strategy = git_strategy_stub(revision_exists: false)
          subject(git_strategy:).call
        end
      end

      def test_that_main_accepts_a_git_object_as_a_revision
        refute_nil subject(revision: GitObjectStub.new).call
      end

      def test_that_main_accepts_an_integer_version_as_a_revision
        refute_nil subject(revision: 32).call
      end

      def test_that_main_accepts_a_relative_revision
        refute_nil subject(revision: 'HEAD~1').call
      end

      def test_that_error_on_tmp_dir_resolution_is_propagated
        assert_raises(DirectoryError) do
          file_strategy = file_strategy_stub(create_success: false)
          subject(file_strategy:).call
        end
      end

      private

      def subject(folder: 'x', revision: 'HEAD', file_strategy: file_strategy_stub, git_strategy: git_strategy_stub)
        Main.new(folder:, revision:, file_strategy:, git_strategy:)
      end

      def file_strategy_stub(dir_exists: true, create_success: true)
        FileStrategyStub.new(dir_exists, create_success)
      end

      def git_strategy_stub(revision_exists: true, object: GitObjectStub.new)
        GitStrategyStub.new(revision_exists, object)
      end

      class GitObjectStub < Git::Object::AbstractObject
        attr_reader :sha

        def initialize(sha: 'abc')
          super(nil, nil)
          @sha = sha
        end
      end

      class FileStrategyStub
        def initialize(dir_exists, create_success)
          @dir_exists = dir_exists
          @create_success = create_success
        end

        def dir_exists?(_folder)
          @dir_exists
        end

        def create_tmp_dir(_sha)
          raise DirectoryError unless @create_success

          'some_tpm_dir'
        end
      end

      class GitStrategyStub
        attr_reader :object

        def initialize(revision_exists, object)
          @revision_exists = revision_exists
          @object = object
        end

        def revision_exists?(_revision)
          @revision_exists
        end
      end
    end
  end
end
