# frozen_string_literal: true

module FilesInMyDiff
  module Git
    class Diff
      def initialize(object:, revision:)
        @object = object
        @revision = revision
      end

      def validate!
        raise ValidationError, "Revision #{@revision} does not exist" if @object.nil?
      end

      def sha
        @object.sha
      end

      def changes
        parent = @object.parents.first
        return [] if parent.nil?

        parent.diff(@object).map do |change|
          { path: change.path, type: change.type }
        end
      end
    end
  end
end
