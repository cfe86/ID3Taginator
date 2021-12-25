# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Text
      module Entities
        class Date
          include Extensions::Comparable

          attr_accessor :month, :day

          # constructor
          #
          # @param day [String, Integer] the day
          # @param month [String, Integer] the month
          def initialize(month, day)
            @month = month
            @day = day
          end
        end
      end
    end
  end
end
