# frozen_string_literal: true

module Id3Taginator
  module Util
    module SyncUtil
      # adds synchronization bytes to the given stream. 1111_1111 111X_XXXX will be changed to
      # 1111_1111 0000_0000 111X_XXXX
      # also 1111_1111 0000_0000 must be changed to 1111_1111 0000_0000 0000_0000
      #
      # @param stream [StringIO, IO, File] the stream to add synchronization
      #
      # @return [String] the result byte array represented as a string (str.bytes is the bytes array)
      def self.add_synchronization(stream)
        result = []

        until stream.eof?
          curr = stream.readbyte
          result << curr

          # curr is not FF > nothing to do
          next if curr != 255

          # if this is the end, add 00 for padding
          if stream.eof?
            result << 0
            break
          end

          next_byte = stream.readbyte
          # add 00 if next byte is 111x_xxxx or 00 (FF 00)
          result << 0 if next_byte >= 224 || next_byte.zero?
          stream.seek(-1, IO::SEEK_CUR)
        end

        result.pack('C*')
      end

      # undo synchroniation, means 1111_1111 0000_0000 111X_XXXX -> 1111_1111 111X_XXXX and
      # 1111_1111 0000_0000 0000_0000 -> 1111_1111 0000_0000
      #
      # @param stream [StringIO, IO, File] the stream to remove synchronization
      #
      # @return [String] the result byte array represented as a string (str.bytes is the bytes array)
      def self.undo_synchronization(stream)
        result = []

        until stream.eof?
          curr = stream.readbyte
          result << curr

          # curr is not FF > nothing to do
          next if curr != 255

          # should never happen, since there should be a 00 padding, just in case catch the case if not
          break if stream.eof?

          next_byte = stream.readbyte
          result << next_byte unless next_byte.zero?
        end

        result.pack('C*')
      end
    end
  end
end
