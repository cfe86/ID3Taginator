# frozen_string_literal: true

module Id3Taginator
  module Util
    module MathUtil
      # converts a 4 byte synchsafe array to an integer
      #
      # @param bytes [Array<Integer>] 4 byte array to convert
      #
      # @return [Integer] the 32 bit synchsafe integer
      def self.to_32_synchsafe_integer(bytes)
        size = 0
        bytes.each_with_index do |byte, index|
          size += 128**(4 - 1 - index) * (byte & 0x7f)
        end

        size
      end

      # converts an integer to a 4 byte synchsafe array
      #
      # @param num [Integer] given integer to convert
      #
      # @return [String] 4 byte String representing the 4 byte synchsafe integer (str.bytes)
      def self.from_32_synchsafe_integer(num)
        bytes = Array.new(4, 0)
        bytes.each_with_index do |_, index|
          bytes[(0 - index).abs], num = num.divmod(128**(4 - 1 - index))
        end

        bytes.map(&:chr).join
      end

      # converts a given byte array to the integer representation
      #
      # @param bytes [Array<Integer>] byte array to convert
      #
      # @return [Integer] the integer
      def self.to_number(bytes)
        size = 0
        num_bytes = bytes.length
        bytes.each_with_index do |byte, index|
          size += 256**(num_bytes - 1 - index) * (byte & 0xff)
        end

        size
      end

      # converts the given number to a byte array, optionally it can be padded using the given char
      # e.g. given 5 and padding 6 will be 00 00 05 and converted to a byte array string
      #
      # @param integer [Integer] the integer to convert
      # @param padding_to [Integer] pad with char if the given number in hex form has less chars than padding_to
      # @param char [String] the character to pad
      #
      # @return [String] the returning byte array in String representation
      def self.from_number(integer, padding_to = 0, char = '0')
        integer.to_s(16).rjust(padding_to, char).scan(/../).map { |x| x.hex.chr }.join
      end
    end
  end
end
