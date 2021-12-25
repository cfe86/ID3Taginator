# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Private
      class PrivateFrame < Id3v2Frame
        include HasId

        frame_info nil, :PRIV, :PRIV

        attr_accessor :owner_id, :private_data

        # builds the private frame
        #
        # @param owner_id [String] the owner id
        # @param private_data [String] the private data bytes represented as a String (str.bytes)
        # @param options [Options::Options] options to use
        # @param id3_version [Integer] the id3 version to build the frame for
        #
        # @return [Id3v2Frame] the resulting id3v2 frame
        def self.build_frame(owner_id, private_data, options = nil, id3_version: 3)
          supported?('PRIV', id3_version, options)

          argument_not_nil(owner_id, 'owner_id')
          argument_not_nil(private_data, 'private_data')

          frame = new(frame_id(id3_version, options), 0, build_id3_flags(id3_version), '')
          frame.owner_id = owner_id
          frame.private_data = private_data
          frame
        end

        def process_content(content)
          stream = StringIO.new(content)
          @owner_id = read_stream_until(stream, ZERO)
          @private_data = stream.read
        end

        def content_to_bytes
          "#{@owner_id}\x00#{@private_data}"
        end
      end
    end
  end
end
