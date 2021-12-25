# frozen_string_literal: true

module Id3Taginator
  module Frames
    module BufferFrames
      include Frames::Frameable

      # extracts the recommended buffer size (RBUF/BUF)
      #
      # @return [Frames::Buffer::Entities::Buffer, nil] returns the Buffer
      def recommended_buffer_size
        frame = find_frame(Buffer::RecommendedBufferSizeFrame.frame_id(@major_version, @options))
        Frames::Buffer::Entities::Buffer.new(frame&.buffer_size, frame&.embedded_info_flag, frame&.offset_next_tag)
      end

      # sets the recommended buffer size (RBUF/BUF)
      #
      # @param buffer [Frames::Buffer::Entities::Buffer] the buffer
      def recommended_buffer_size=(buffer)
        set_frame_fields(Buffer::RecommendedBufferSizeFrame, %i[@buffer_size @embedded_info_flag @offset_next_tag],
                         buffer.buffer_size, buffer.embedded_info_flag, buffer.offset_next_tag)
      end
    end
  end
end
