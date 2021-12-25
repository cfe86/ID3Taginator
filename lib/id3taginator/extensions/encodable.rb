# frozen_string_literal: true

module Id3Taginator
  module Extensions
    module Encodable
      def self.included(base)
        base.extend(self)
      end

      ZERO = "\x00"
      UNICODE_ZERO = "\x00\x00"

      ISO8859_1 = 0x00
      UTF_16 = 0x01
      UTF_16BE = 0x02
      UTF_8 = 0x03

      # returns the ZERO byte depending of the given encoding, so 0x00 0x00 for Unicode, else 0x00
      #
      # @param encoding [Encoding] the encoding to determine the zero byte(s)
      #
      # @return [String] the zero byte(s) String
      def zero_byte(encoding = @options.default_encode_dest)
        encoding == Encoding::ISO8859_1 ? ZERO : UNICODE_ZERO
      end

      # finds the encoding byte for the given encoding
      #
      # @param encoding [Encoding] the encoding
      #
      # @return [Integer] the encoding byte for this encoding
      def find_encoding_byte(encoding)
        case encoding
        when Encoding::ISO8859_1
          ISO8859_1
        when Encoding::UTF_8
          UTF_8
        when Encoding::UTF_16
          UTF_16
        when Encoding::UTF_16BE
          UTF_16BE
        else
          raise Errors::Id3TagError, "#{encoding} is not a valid encoding."
        end
      end

      # finds the encoding for the given encoding Byte
      #
      # @param encoding_byte [Integer] the encoding byte
      #
      # @return [Encoding] the encoding for this encoding byte
      def find_encoding(encoding_byte)
        case encoding_byte
        when ISO8859_1
          Encoding::ISO8859_1
        when UTF_8
          Encoding::UTF_8
        when UTF_16
          Encoding::UTF_16
        when UTF_16BE
          Encoding::UTF_16BE
        else
          raise Errors::Id3TagError, "#{encoding_byte} is not a valid encoding bit."
        end
      end

      # returns the default destination encoding byte
      #
      # @return [String] the String representation of the default destination encoding byte
      def default_encoding_destination_byte
        [find_encoding_byte(@options.default_encode_dest)].pack('C*')
      end

      # reads the given stream until the byte combination is found
      #
      # @param stream [StringIO, IO, File] the stream
      # @param until_bytes [String] read stream until this combination is found
      #
      # @return [String] String representation of the bytes array that is read
      def read_stream_until(stream, until_bytes)
        result = []
        size = until_bytes.length
        until (read = stream.read(size)).nil?
          break if read == until_bytes

          result << read&.bytes
        end

        result.flatten.pack('C*')
      end

      # merges the given string representing a byte array to a String representation of the merged byte arrays
      #
      # @param str [Array<String>] byte arrays represented as a String to merge
      #
      # @return [String] String representation of the merged byte arrays (str.bytes)
      def merge(*str)
        str.inject([]) { |sum, x| sum + x.bytes }.pack('C*')
      end

      # decodes the given string using the encoding byte (first byte of the string)
      #
      # @param str [String] String to decode using the first byte to determine the encoding
      #
      # @return [String] the decoded String
      def decode_using_encoding_byte(str)
        encoding_byte = str[0]&.bytes&.first
        encoding = find_encoding(encoding_byte)

        decode(str[1..-1], encoding)
      end

      # encode the given String from source encoding to destination encoding and adds the destination encoding
      # byte as the first byte
      #
      # @param str [String] the String to encode
      # @param source_encoding [Encoding] the source encoding
      # @param dest_encoding [Encoding] the destination encoding
      #
      # @return [String] the encoded String with the encoding byte as first byte
      def encode_and_add_encoding_byte(str, source_encoding = @options.default_decode_dest,
                                       dest_encoding = @options.default_encode_dest)
        encoding_byte = find_encoding_byte(dest_encoding)
        result = encode_string(str, source_encoding, dest_encoding)
        result = remove_trailing_zeros(result)
        bytes = result.bytes
        bytes.unshift(encoding_byte)

        bytes.flatten.pack('C*')
      end

      # decodes the given String from the default destination decoding to the given source encoding
      #
      # @param str [String] the String to decode
      # @param source_encoding [Encoding] the result encoding
      #
      # @return [String] the decoded String
      def decode(str, source_encoding = @options.default_encode_dest)
        result = encode_string(str, source_encoding, @options.default_decode_dest)
        remove_trailing_zeros(result)
      end

      # encodes the given String from the default destination encoding to the given source encoding
      #
      # @param str [String] the String to decode
      # @param source_encoding [Encoding] the result encoding
      #
      # @return [String] the encoded String
      def encode(str, source_encoding = @options.default_decode_dest, null_terminated: false)
        encode_string(str, source_encoding, @options.default_encode_dest, null_terminated: null_terminated)
      end

      # encodes the given String from source to destination encoding and optionally adds a null termination byte(s)
      #
      # @param str [String] the String to encode
      # @param source_encoding [Encoding] source encoding
      # @param dest_encoding [Encoding] destination encoding
      # @param null_terminated [Boolean] true, if null termination byte(s) should be added
      #
      # @return [String] the encoded String and if requested, added null termination byte(s)
      def encode_string(str, source_encoding, dest_encoding, null_terminated: false)
        if str.empty? && null_terminated && dest_encoding != Encoding::ISO8859_1
          return [0xFE, 0xFF, 0x00, 0x00].pack('C*')
        end

        res = str.encode(dest_encoding, source_encoding)
        null_terminated ? merge(res, zero_byte(dest_encoding)) : res
      end

      # removes trailing zero bytes if present
      #
      # @param str [String] the string to remove the trailing zeros if present
      #
      # @return [String] the String without trailing zeros
      def remove_trailing_zeros(str)
        return str if str.empty?

        last = str.bytes.last
        while last&.zero?
          str.chop!
          last = str.bytes.last
        end

        str
      end

      # pads the given String with X chars to the left
      #
      # @param str [String] the String to pad
      # @param padding_to [Integer] pad until length of
      # @param char [String] the char to use to pad
      #
      # @return [String] the padded String
      def pad_left(str, padding_to, char = 0.chr)
        str ||= ''
        str.ljust(padding_to, char)
      end

      # pads the given String with X chars to the right
      #
      # @param str [String] the String to pad
      # @param padding_to [Integer] pad until length of
      # @param char [String] the char to use to pad
      #
      # @return [String] the padded String
      def pad_right(str, padding_to, char = 0.chr)
        str ||= ''
        str.rjust(padding_to, char)
      end
    end
  end
end
