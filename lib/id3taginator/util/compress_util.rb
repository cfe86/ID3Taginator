# frozen_string_literal: true

module Id3Taginator
  module Util
    module CompressUtil
      # compresses the passed data via Zlib
      #
      # @param data [String] the data to compress
      #
      # @return [String] compressed data
      def self.decompress_data(data)
        Zlib::Inflate.inflate(data)
      end

      # decompresses the passed data via Zlib
      #
      # @param data [String] the data to decompress, this must be compressed by Zlib before
      #
      # @return [String] decompressed data
      def self.compress_data(data)
        Zlib::Deflate.deflate(data)
      end
    end
  end
end
