# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Text
      module Entities
        class PartOfSet
          include Extensions::Comparable

          attr_accessor :part, :total

          # constructor
          #
          # @param part [String, Integer] part of the set
          # @param total [String, Integer, nil] total number of parts
          def initialize(part, total)
            @part = part
            @total = total
          end
        end
      end
    end
  end
end
