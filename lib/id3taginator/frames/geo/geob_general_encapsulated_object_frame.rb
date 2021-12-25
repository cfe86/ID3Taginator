# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Geo
      class GeneralEncapsulatedObjectFrame < Id3v2Frame
        include HasId

        frame_info :GEO, :GEOB, :GEOB

        attr_accessor :mime_type, :filename, :descriptor, :object_data

        # builds the general encapsulated object frame
        #
        # @param mime_type [String] the mime type of the object e.g. image/png
        # @param filename [String] the filename
        # @param descriptor [String] the description
        # @param object_data [String] the object data bytes represented as a String (str.bytes)
        # @param options [Options::Options] options to use
        # @param id3_version [Integer] the id3 version to build the frame for
        #
        # @return [Id3v2Frame] the resulting id3v2 frame
        def self.build_frame(mime_type, filename, descriptor, object_data, options = nil, id3_version: 3)
          supported?('GEOB', id3_version, options)

          mime_type ||= ''
          filename ||= ''
          descriptor ||= ''
          argument_not_nil(object_data, 'object_data')

          frame = new(frame_id(id3_version, options), 0, build_id3_flags(id3_version), '')
          frame.mime_type = mime_type
          frame.filename = filename
          frame.descriptor = descriptor
          frame.object_data = object_data
          frame
        end

        def process_content(content)
          stream = StringIO.new(content)
          encoding = find_encoding(stream.readbyte)

          @mime_type = read_stream_until(stream, ZERO)
          encoded_filename = read_stream_until(stream, zero_byte(encoding))
          @filename = decode(encoded_filename, encoding)
          encoded_descriptor = read_stream_until(stream, zero_byte(encoding))
          @descriptor = decode(encoded_descriptor, encoding)
          @object_data = stream.read
        end

        def content_to_bytes
          encoded_filename = encode(@filename, null_terminated: true)
          encoded_descriptor = encode(@descriptor, null_terminated: true)
          merge(default_encoding_destination_byte, @mime_type, ZERO, encoded_filename, encoded_descriptor, @object_data)
        end
      end
    end
  end
end
