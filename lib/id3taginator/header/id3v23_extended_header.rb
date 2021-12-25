# frozen_string_literal: true

module Id3Taginator
  module Header
    class Id3v23ExtendedHeader

      attr_accessor :size, :flags, :padding, :crc_data

      # constructor
      #
      # @param size [Integer] the size of the extended header
      # @param flags [Array<Integer>] 2 byte Array representing the flags
      # @param padding [Integer] the number of padding of the extended header
      # @param crc_data [String] the crc data if present
      def initialize(size, flags, padding, crc_data = nil)
        @size = size
        @flags = flags
        @padding = padding
        @crc_data = crc_data
      end

      # returns the CRC data if present
      #
      # @return [String, nil] the CRC data
      def crc
        @crc_data
      end

      # determined if the crc is present
      #
      # @return [Boolean] true if crc is present, else false
      def crc?
        (@flags & 0b10000000) == 0b10000000
      end
    end
  end
end
