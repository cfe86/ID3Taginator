# frozen_string_literal: true

module Id3Taginator
  module Header
    class Id3v24ExtendedHeader

      attr_accessor :size, :flags

      # constructor
      #
      # @param size [Integer] the size of the extended header
      # @param flags [Array<Integer>] 2 byte Array representing the flags
      def initialize(size, flags)
        @size = size
        @flags = flags
        @tag_is_update = false
        @crc_data = nil
        @restrictions = 0b00000000

        flags_stream = StringIO.new(flags)
        ext_flag = flags_stream.readbyte
        # tag is update
        if bit_set?(ext_flag, 0b01000000)
          @tag_is_update = true
          flags_stream.readbyte
        end

        # crc data
        if bit_set?(ext_flag, 0b00100000)
          length = ext_flag.readbyte
          @crc_data = flags_stream.read(length)
        end

        ext_flag.readbyte if bit_set?(ext_flag, 0b00010000)
        @restrictions = ext_flag.readbyte if bit_set?(ext_flag, 0b00010000)
      end

      # determined if the tag is an update
      #
      # @return [Boolean] true if it is an update, else false
      def tag_is_an_update?
        @tag_is_update
      end

      # returns the CRC data if present
      #
      # @return [String, nil] the CRC data
      def crc
        @crc_data
      end

      # determined if the tag is size restricted
      #
      # @return [Boolean] true if it restricted, else false
      def tag_size_restrictions?
        (@restrictions & 0b11000000) == 0b11000000
      end

      # determined if the tag is text encoding restricted
      #
      # @return [Boolean] true if text encoding restricted, else false
      def text_encoding_restrictions?
        (@restrictions & 0b00100000) == 0b00100000
      end

      # determined if the tag is fields size restricted
      #
      # @return [Boolean] true if fields size restricted, else false
      def text_fields_size_restrictions?
        (@restrictions & 0b00011000) == 0b00011000
      end

      # determined if the tag is encoding restricted
      #
      # @return [Boolean] true if encoding restricted, else false
      def image_encoding_restrictions?
        (@restrictions & 0b00000100) == 0b00000100
      end

      # determined if the tag is image encoding restricted
      #
      # @return [Boolean] true if image encoding restricted, else false
      def image_size_restrictions?
        (@restrictions & 0b00000011) == 0b00000011
      end

      # checks if the given bit of the given byte is set
      #
      # @param byte [Integer] the byte to check if a specific bit is set
      # @param set [Byte] the Byte where the bit is set that should be checked
      #
      # @return [Boolean] true if the bit is set, else false
      def bit_set?(byte, set)
        (byte & set) == set
      end

      private :bit_set?
    end
  end
end
