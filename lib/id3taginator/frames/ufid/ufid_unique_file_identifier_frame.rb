# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Ufid
      class UniqueFileIdentifierFrame < Id3v2Frame
        include HasId

        frame_info :UFI, :UFID, :UFID

        attr_accessor :owner_id, :identifier

        # builds the unique file identifier frame
        #
        # @param owner_id [String] the owner id
        # @param identifier [String] the identifier bytes represented as a String (str.bytes)
        # @param options [Options::Options] options to use
        # @param id3_version [Integer] the id3 version to build the frame for
        #
        # @return [Id3v2Frame] the resulting id3v2 frame
        def self.build_frame(owner_id, identifier, options = nil, id3_version: 3)
          supported?('UFID', id3_version, options)

          argument_not_nil(owner_id, 'owner_id')
          argument_not_nil(identifier, 'identifier')

          argument_less_than_chars(identifier, 'identifier', 64)

          frame = new(frame_id(id3_version, options), 0, build_id3_flags(id3_version), '')
          frame.owner_id = owner_id
          frame.identifier = identifier
          frame
        end

        def process_content(content)
          stream = StringIO.new(content)
          @owner_id = read_stream_until(stream, ZERO)
          @identifier = stream.read
        end

        def content_to_bytes
          "#{@owner_id}\x00#{@identifier}"
        end
      end
    end
  end
end
