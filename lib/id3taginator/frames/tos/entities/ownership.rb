# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Tos
      module Entities
        class Ownership
          include Extensions::Comparable

          attr_accessor :price_paid, :date_of_purchase, :seller

          # constructor
          #
          # @param price_paid [String] the paid price. e.g. $19.99
          # @param date_of_purchase [String] date of purchase in the format YYYYMMDD
          # @param seller [String] the seller
          def initialize(price_paid, date_of_purchase, seller)
            @price_paid = price_paid
            @date_of_purchase = date_of_purchase
            @seller = seller
          end
        end
      end
    end
  end
end
