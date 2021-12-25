# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Encryption
      class AudioEncryptionFrame < Id3v2Frame
        include HasId

        frame_info :CRA, :AENC, :AENC

        attr_accessor :owner_id, :preview_start, :preview_length, :encryption_info

        # builds the audio encryption frame
        #
        # @param owner_id [String] the owner id
        # @param preview_start [Integer] the start frame of the preview
        # @param preview_length [Integer] the preview length in frames
        # @param encryption_info [String] encryption info bytes represented as a String (str.bytes)
        # @param options [Options::Options] options to use
        # @param id3_version [Integer] the id3 version to build the frame for
        #
        # @return [Id3v2Frame] the resulting id3v2 frame
        def self.build_frame(owner_id, preview_start, preview_length, encryption_info, options = nil, id3_version: 3)
          supported?('AENC', id3_version, options)

          argument_not_nil(owner_id, 'owner_id')
          argument_not_nil(preview_start, 'preview_start')
          argument_not_nil(preview_length, 'preview_length')
          argument_not_nil(encryption_info, 'encryption_info')

          frame = new(frame_id(id3_version, options), 0, build_id3_flags(id3_version), '')
          frame.owner_id = owner_id
          frame.preview_start = preview_start
          frame.preview_length = preview_length
          frame.encryption_info = encryption_info
          frame
        end

        def process_content(content)
          stream = StringIO.new(content)
          @owner_id = read_stream_until(stream, ZERO)
          @preview_start = Util::MathUtil.to_number(stream.read(2)&.bytes)
          @preview_length = Util::MathUtil.to_number(stream.read(2)&.bytes)
          @encryption_info = stream.read
        end

        def content_to_bytes
          merge(@owner_id, "\x00", Util::MathUtil.from_number(@preview_start, 4),
                Util::MathUtil.from_number(@preview_length, 4), @encryption_info)
        end
      end
    end
  end
end
