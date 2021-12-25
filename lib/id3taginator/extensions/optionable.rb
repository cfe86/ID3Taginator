# frozen_string_literal: true

module Id3Taginator
  module Extensions
    module Optionable
      # sets the default encoding for destination
      #
      # @param encoding [Encoding] the encoding to set
      #
      # @return [Self] returns self for builder style
      def default_encode_for_destination(encoding)
        raise Errors::Id3TagError, 'Encoding can\'t be nil' if encoding.nil?

        @options.default_encode_dest = encoding
        self
      end

      # sets the default decoding for destination
      #
      # @param encoding [Encoding] the encoding to set
      #
      # @return [Self] returns self for builder style
      def default_decode_for_destination(encoding)
        raise Errors::Id3TagError, 'Encoding can\'t be nil' if encoding.nil?

        @options.default_decode_dest = encoding
        self
      end

      # sets the padding
      #
      # @param number_bytes [Integer] number of bytes to pad
      #
      # @return [Self] returns self for builder style
      def tag_padding(number_bytes)
        number_bytes = 0 if number_bytes.nil?
        @options.padding_bytes = number_bytes
        self
      end

      # if true, does not throw an error if a frame is added that is not supported for 2.3 e.g. Sort Order Frames
      #
      # @param ignore [Boolean] true to ignore errors, else false
      #
      # @return [Self] returns self for builder style
      def ignore_v23_frame_error(ignore = true)
        @options.ignore_v23_frame_error = ignore
        self
      end

      # if true, does not throw an error if a frame is added that is not supported for 2.4 e.g. Size Frame
      #
      # @param ignore [Boolean] true to ignore errors, else false
      #
      # @return [Self] returns self for builder style
      def ignore_v24_frame_error(ignore = true)
        @options.ignore_v24_frame_error = ignore
        self
      end

      # if true, the size frame TSIZ will be added automatically to v2.3 if not present. Will be added to v2.4 if
      # ignore_v24_frame_error is true

      # @param add_frame [Boolean] true to add the frame automatically if not present, else false
      #
      # @return [Self] returns self for builder style
      def add_size_frame(add_frame = true)
        @options.add_size_frame = add_frame
        self
      end
    end
  end
end
