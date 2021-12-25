# frozen_string_literal: true

module Id3Taginator
  module Frames
    class Id3v2Frame
      include Extensions::Encodable
      include Extensions::ArgumentCheck

      HEADER_SIZE_V_3_4 = 10
      HEADER_SIZE_V_2 = 6

      attr_accessor :options
      attr_reader :frame_id

      # builds an id3v2.2 frame of the given frame id and the given data stream. The data stream(0) must be after
      # the frame id
      #
      # @param frame_id [String] the frame id
      # @param file [StringIO, IO, file] the data stream
      # @param options [Options::Options] the options to use
      #
      # @return [Id3v2Frame] the build id3v2.2 frame
      def self.build_v2_frame(frame_id, file, options)
        payload_size = Util::MathUtil.to_number(file.read(3)&.bytes)
        frame_payload = file.read(payload_size)

        instance = new(frame_id, payload_size, nil, frame_payload, HEADER_SIZE_V_2, nil)
        instance.options = options
        instance.process_content(frame_payload)
        instance
      end

      # builds an id3v2.3 frame of the given frame id and the given data stream. The data stream(0) must be after
      # the frame id
      #
      # @param frame_id [String] the frame id
      # @param file [StringIO, IO, file] the data stream
      # @param options [Options::Options] the options to use
      #
      # @return [Id3v2Frame] the build id3v2.3 frame
      def self.build_v3_frame(frame_id, file, options)
        payload_size = Util::MathUtil.to_number(file.read(4)&.bytes)
        flags = Id3v23FrameFlags.new(file.read(2))
        decompressed_size = Util::MathUtil.to_number(file.read(4)&.bytes) if flags.compression?

        if flags.compression?
          compressed_data = file.read(payload_size)
          frame_payload = Util::CompressUtil.decompress_data(compressed_data)
          # noinspection RubyScope
          payload_size = decompressed_size
        else
          frame_payload = file.read(payload_size)
        end

        group_identify = nil
        if flags.group_identity?
          group_identify = frame_payload[0]
          frame_payload = frame_payload[1..-1]
        end

        instance = new(frame_id, payload_size, flags, frame_payload, HEADER_SIZE_V_3_4, group_identify)
        instance.options = options
        instance.process_content(frame_payload)
        instance
      end

      # builds an id3v2.4 frame of the given frame id and the given data stream. The data stream(0) must be after
      # the frame id
      #
      # @param frame_id [String] the frame id
      # @param file [StringIO, IO, file] the data stream
      # @param options [Options::Options] the options to use
      #
      # @return [Id3v2Frame] the build id3v2.4 frame
      def self.build_v4_frame(frame_id, file, options)
        payload_size = Util::MathUtil.to_32_synchsafe_integer(file.read(4)&.bytes)
        flags = Id3v24FrameFlags.new(file.read(2))

        frame_payload = file.read(payload_size)
        frame_payload = Util::SyncUtil.undo_synchronization(StringIO.new(frame_payload)) if flags.unsynchronisation?
        frame_payload = Util::CompressUtil.decompress_data(frame_payload) if flags.compression?

        group_identify = nil
        if flags.group_identity?
          group_identify = frame_payload[0]
          frame_payload = frame_payload[1..-1]
        end

        instance = new(frame_id, payload_size, flags, frame_payload, HEADER_SIZE_V_3_4, group_identify)
        instance.options = options
        instance.process_content(frame_payload)
        instance
      end

      def self.build_id3_flags(version, flags = "\x00\x00")
        case version
        when 2
          nil
        when 3
          Id3v23FrameFlags.new(flags)
        when 4
          Id3v24FrameFlags.new(flags)
        else
          raise Errors::Id3TagError, "Id3v.2.#{version} is not supported."
        end
      end

      # Constructor
      #
      # @param frame_id [String] the frame id
      # @param payload_size [Integer] the payload size (excludes header)
      # @param flags [Id3v23FrameFlags, Id3v24FrameFlags] the frame flags
      # @param frame_payload [String] the decompressed and unsynchronized payload
      # @param header_size [Integer] the frame header size, 6 vor v2, 10 otherwise
      # @param group_identify [String] the group identify if present
      def initialize(frame_id, payload_size, flags, frame_payload, header_size = 10, group_identify = nil)
        @header_size = header_size
        @frame_id = frame_id.to_sym
        @payload_size = payload_size
        @flags = flags
        @frame_payload = frame_payload
        @group_identity = group_identify
      end

      # processes the frame payload for the specific frame
      #
      # @param _content [String] the frame payload
      def process_content(_content)
        raise NotImplementedError, 'Implement this in a the actual frame class.'
      end

      # dumps the frame content to the byte representation as a String
      #
      # @return [String] the byte array as String
      def content_to_bytes
        raise NotImplementedError, 'Implement this in the actual frame class.'
      end

      # dumps the frame to a byte string. This dump already takes unsynchronization, padding and all other
      # options into effect
      #
      # @return [String] frame dump as a String. tag.bytes represents the byte array
      def to_bytes
        size_padding = @frame_id.to_s.length == 3 ? 6 : 8
        payload = content_to_bytes
        payload_size_decompressed = Util::MathUtil.from_number(payload.length, size_padding)

        result = @frame_id.to_s
        if @flags&.compression?
          payload_compressed = Util::CompressUtil.compress_data(payload)
          payload_size_compressed = payload_compressed.size
          result += Util::MathUtil.from_number(payload_size_compressed, size_padding)
        else
          result += payload_size_decompressed
        end

        result += @flags.to_bytes unless @flags.nil?
        result += payload_size_decompressed if @flags&.compression?
        result += @group_identity if @flags&.group_identity?

        # noinspection RubyScope
        result += @flags&.compression? ? payload_compressed : payload

        result
      end

      # recalculates the payload size
      def re_calc_payload_size
        @payload_size = content_to_bytes.length
      end

      # calculates the frame size including header and payload, takes compression, group identity and everything
      # into effect
      #
      # @return [Integer] the frame size in bytes
      def frame_size
        compression = compression? ? 4 : 0
        group_identity = group_identity? ? 1 : 0

        # noinspection RubyMismatchedReturnType
        @header_size + @payload_size + compression + group_identity
      end

      # determined if the frame is alter preserved
      #
      # @return [Boolean] true if alter preserved, else false
      def tag_alter_preservation?
        return false if @flags.nil?

        @flags.tag_alter_preservation?
      end

      # determined if the file is alter preserved
      #
      # @return [Boolean] true if the file is alter preserved, else false
      def file_alter_preservation?
        return false if @flags.nil?

        @flags.file_alter_preservation?
      end

      # determined if the file frame is read only
      #
      # @return [Boolean] true if frame is read only, else false
      def read_only?
        return false if @flags.nil?

        @flags.read_only?
      end

      # determined if the frame is compressed
      #
      # @return [Boolean] true if the frame is compressed, else false
      def compression?
        return false if @flags.nil?

        @flags.compression?
      end

      # determined if the frame is encrypted
      #
      # @return [Boolean] true if the frame is encrypted, else false
      def encryption?
        return false if @flags.nil?

        @flags.encryption?
      end

      # determined if the frame has a group identity
      #
      # @return [Boolean] true if the frame has a group identity, else false
      def group_identity?
        return false if @flags.nil?

        @flags.group_identity?
      end
    end
  end
end
