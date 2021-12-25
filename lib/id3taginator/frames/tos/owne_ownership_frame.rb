# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Tos
      class OwnershipFrame < Id3v2Frame
        include HasId

        frame_info nil, :OWNE, :OWNE

        attr_accessor :price_paid, :date_of_purchase, :seller

        # builds the ownership frame
        #
        # @param price_paid [String] the paid price. e.g. $19.99
        # @param date_of_purchase [String] date of purchase in the format YYYYMMDD
        # @param seller [String] the seller
        # @param options [Options::Options] options to use
        # @param id3_version [Integer] the id3 version to build the frame for
        #
        # @return [Id3v2Frame] the resulting id3v2 frame
        def self.build_frame(price_paid, date_of_purchase, seller, options = nil, id3_version: 3)
          supported?('OWNE', id3_version, options)

          argument_not_nil(price_paid, 'price_paid')
          argument_not_nil(date_of_purchase, 'date_of_purchase')
          argument_exactly_chars(date_of_purchase, 'date_of_purchase', 8)
          argument_not_nil(seller, 'seller')

          frame = new(frame_id(id3_version, options), 0, build_id3_flags(id3_version), '')
          frame.price_paid = price_paid
          frame.date_of_purchase = date_of_purchase
          frame.seller = seller
          frame
        end

        def process_content(content)
          stream = StringIO.new(content)
          encoding = find_encoding(stream.readbyte)
          @price_paid = read_stream_until(stream, ZERO)
          @date_of_purchase = stream.read(8)
          encoded_seller = stream.read
          @seller = decode(encoded_seller, encoding)
        end

        def content_to_bytes
          encoded_seller = encode(@seller)
          merge(default_encoding_destination_byte, @price_paid, "\x00", @date_of_purchase, encoded_seller)
        end
      end
    end
  end
end
