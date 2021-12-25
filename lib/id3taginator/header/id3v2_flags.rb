# frozen_string_literal: true

module Id3Taginator
  module Header
    class Id3v2Flags

      # constructor
      #
      # @param flags [Integer] the 1 byte header flag
      def initialize(flags)
        @flags = flags
      end

      # determined if the tag is unsynchronized
      #
      # @return [Boolean] true if unsynchronized, else false
      def unsynchronized?
        (@flags & 0b1000_0000) == 0b1000_0000
      end

      # enables or synchronization for the tag
      #
      # @param enabled [Boolean] true, if tag should be synchronized, else false
      def unsynchronized=(enabled)
        @flags = enabled ? @flags | 0b1000_0000 : @flags & 0b0111_1111
      end

      # determines if an extended header is present
      #
      # @return [Boolean] true if header is present, else false
      def extended_header?
        (@flags & 0b0100_0000) == 0b0100_0000
      end

      # determines if experimental tags are present
      #
      # @return [Boolean] true if experimental tags present, else false
      def experimental?
        (@flags & 0b0010_0000) == 0b0010_0000
      end

      # determines if a footer is present
      #
      # @return [Boolean] true if a footer is present, else false
      def footer?
        (@flags & 0b0001_0000) == 0b0001_0000
      end

      # enables or disables a footer
      #
      # @param enabled [Boolean] true, if the footer should be set to the tag, else false
      def footer=(enabled)
        @flags = enabled ? @flags | 0b0001_0000 : @flags & 0b1110_1111
      end

      # dumps the flags to a byte string
      #
      # @return [String] the String representing the flags
      def to_bytes
        @flags.chr
      end
    end
  end
end
