# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Comment
      module Entities
        class Comment
          include Extensions::Comparable

          attr_accessor :language, :descriptor, :text

          # constructor
          #
          # @param language [String] the language of the comment (3 characters)
          # @param descriptor [String] description
          # @param text [String] the comment text
          def initialize(language, descriptor, text)
            @language = language
            @descriptor = descriptor
            @text = text
          end
        end
      end
    end
  end
end
