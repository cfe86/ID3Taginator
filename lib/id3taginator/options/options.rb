# frozen_string_literal: true

module Id3Taginator
  module Options
    class Options

      attr_accessor :default_encode_dest, :default_decode_dest, :padding_bytes, :ignore_v23_frame_error,
                    :ignore_v24_frame_error, :add_size_frame

      # options that are passed through and applied during read and write
      #
      # @param default_encode_dest [Encoding] destination encoding is the default encoding that is used for the id3tag
      # @param default_decode_dest [Encoding] destination decoding is the default encoding that is used when the id3tag
      #                                       encoding is decoded
      # @param padding_bytes [Integer] the default padding to add at the end of the tag
      # @param ignore_v23_frame_error [Boolean] if true, does not throw an error if a frame is added that is not
      #                                         supported for 2.3 e.g. Sort Order Frames
      # @param ignore_v24_frame_error [Boolean] if true, does not throw an error if a frame is added that is not
      #                                         supported for 2.4 e.g. Size Frame
      # @param add_size_frame [Boolean] if true, the size frame TSIZ will be added automatically to v2.3. Will be added
      #                                 to v2.4 if ignore_v24_frame_error is true
      def initialize(default_encode_dest = Encoding::UTF_16, default_decode_dest = Encoding::UTF_8, padding_bytes = 25,
                     ignore_v23_frame_error = true, ignore_v24_frame_error = true, add_size_frame = false)
        @default_encode_dest = default_encode_dest
        @default_decode_dest = default_decode_dest
        @padding_bytes = padding_bytes
        @ignore_v23_frame_error = ignore_v23_frame_error
        @ignore_v24_frame_error = ignore_v24_frame_error
        @add_size_frame = add_size_frame
      end
    end
  end
end
