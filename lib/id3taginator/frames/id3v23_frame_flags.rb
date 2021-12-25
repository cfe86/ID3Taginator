# frozen_string_literal: true

module Id3Taginator
  module Frames
    class Id3v23FrameFlags

      def initialize(flags)
        @flags = flags
      end

      def to_bytes
        @flags
      end

      # determined if the frame is alter preserved
      #
      # @return [Boolean] true if alter preserved, else false
      def tag_alter_preservation?
        flag = @flags.bytes[0]
        (flag & 0b1000_0000) == 0b1000_0000
      end

      # determined if the file is alter preserved
      #
      # @return [Boolean] true if the file is alter preserved, else false
      def file_alter_preservation?
        flag = @flags.bytes[0]
        (flag & 0b0100_0000) == 0b0100_0000
      end

      # determined if the file frame is read only
      #
      # @return [Boolean] true if frame is read only, else false
      def read_only?
        flag = @flags.bytes[0]
        (flag & 0b0010_0000) == 0b0010_0000
      end

      # determined if the frame is compressed
      #
      # @return [Boolean] true if the frame is compressed, else false
      def compression?
        flag = @flags.bytes[1]
        (flag & 0b1000_0000) == 0b1000_0000
      end

      # determined if the frame is encrypted
      #
      # @return [Boolean] true if the frame is encrypted, else false
      def encryption?
        flag = @flags.bytes[1]
        (flag & 0b0100_0000) == 0b0100_0000
      end

      # determined if the frame has a group identity
      #
      # @return [Boolean] true if the frame has a group identity, else false
      def group_identity?
        flag = @flags.bytes[1]
        (flag & 0b0010_0000) == 0b0010_0000
      end
    end
  end
end
