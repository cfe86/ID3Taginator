# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Count
      module Entities
        class Popularimeter
          include Extensions::Comparable

          attr_accessor :email, :rating, :counter

          # constructor
          #
          # @param email [String] email of the user
          # @param rating [Integer] the rating between 0 and 255
          # @param counter [Integer] the counter, default 32 bit integer, but can be higher too
          def initialize(email, rating, counter)
            @email = email
            @rating = rating
            @counter = counter
          end
        end
      end
    end
  end
end
