# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Tos
      module Entities
        class TermsOfUse
          include Extensions::Comparable

          attr_accessor :language, :text

          # constructor
          #
          # @param language [String] the 3 character language of the terms of use
          # @param text [String] the terms of use text
          def initialize(language, text)
            @language = language
            @text = text
          end
        end
      end
    end
  end
end
