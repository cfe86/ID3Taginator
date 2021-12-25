# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Text
      module Entities
        class Time
          include Extensions::Comparable

          attr_accessor :hours, :minutes

          # constructor
          #
          # @param hours [String, Integer] the hours
          # @param minutes [String, Integer] the minutes
          def initialize(hours, minutes)
            @hours = hours
            @minutes = minutes
          end
        end
      end
    end
  end
end
