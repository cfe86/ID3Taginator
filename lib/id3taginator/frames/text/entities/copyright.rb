# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Text
      module Entities
        class Copyright
          include Extensions::Comparable

          attr_accessor :year, :holder

          # constructor
          #
          # @param year [String] the 4 character year e.g. 2020
          # @param holder [String] the copyright holder
          def initialize(year, holder)
            @year = year
            @holder = holder
          end
        end
      end
    end
  end
end
