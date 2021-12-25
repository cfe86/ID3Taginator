# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Grouping
      class GroupIdentificationFrame < Id3v2Frame
        include HasId

        frame_info nil, :GRID, :GRID

        attr_accessor :owner_id, :group_symbol, :group_dependant_data

        # builds the group identification frame
        #
        # @param owner_id [String] the owner id
        # @param group_symbol [Integer] the group symbol, number between 0 and 255
        # @param group_dependant_data [String] data bytes represented as a String (str.bytes)
        # @param options [Options::Options] options to use
        # @param id3_version [Integer] the id3 version to build the frame for
        #
        # @return [Id3v2Frame] the resulting id3v2 frame
        def self.build_frame(owner_id, group_symbol, group_dependant_data, options = nil, id3_version: 3)
          supported?('GRID', id3_version, options)

          argument_not_nil(owner_id, 'owner_id')
          argument_between_num(group_symbol, 'group_symbol', 0, 255)
          argument_not_nil(group_dependant_data, 'group_dependant_data')

          frame = new(frame_id(id3_version, options), 0, build_id3_flags(id3_version), '')
          frame.owner_id = owner_id
          frame.group_symbol = group_symbol
          frame.group_dependant_data = group_dependant_data
          frame
        end

        def process_content(content)
          stream = StringIO.new(content)
          @owner_id = read_stream_until(stream, ZERO)
          @group_symbol = stream.readbyte
          @group_dependant_data = stream.read
        end

        def content_to_bytes
          merge(@owner_id, "\x00", @group_symbol.chr, @group_dependant_data)
        end
      end
    end
  end
end
