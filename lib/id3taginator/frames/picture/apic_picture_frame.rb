# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Picture
      class PictureFrame < Id3v2Frame
        include HasId

        frame_info :PIC, :APIC, :APIC

        LINK_MIME = '-->'

        attr_accessor :mime_type, :picture_type, :descriptor, :picture_data

        # builds the picture frame
        #
        # @param mime_type [String] the mime type e.g. image/png. '-->' if the image is a reference, e.g. a URI
        # @param picture_type [Symbol, nil] the picture type, all types can be found in Picture::PictureType
        # @param descriptor [String] the description
        # @param picture_data [String] the picture data bytes represented as a String (str.bytes)
        # @param options [Options::Options] options to use
        # @param id3_version [Integer] the id3 version to build the frame for
        #
        # @return [Id3v2Frame] the resulting id3v2 frame
        def self.build_frame(mime_type, picture_type, descriptor, picture_data, options = nil, id3_version: 3)
          supported?('APIC', id3_version, options)

          argument_not_nil(mime_type, 'mime_type')
          descriptor ||= ''
          argument_less_than_chars(descriptor, 'descriptor', 64)
          argument_not_nil(picture_data, 'picture_data')

          picture_type ||= :OTHER

          argument_sym(picture_type, 'picture_type')

          mime_type = "image/#{mime_type}" if !mime_type.include?('/') && mime_type != LINK_MIME

          frame = new(frame_id(id3_version, options), 0, build_id3_flags(id3_version), '')
          frame.mime_type = mime_type
          frame.picture_type = picture_type
          frame.descriptor = descriptor
          frame.picture_data = picture_data
          frame
        end

        def process_content(content)
          stream = StringIO.new(content)
          encoding = find_encoding(stream.readbyte)
          @mime_type = read_stream_until(stream, ZERO)
          @picture_type = PictureType.type_by_value(stream.readbyte)
          encoded_descriptor = read_stream_until(stream, zero_byte(encoding))
          @descriptor = decode(encoded_descriptor, encoding)
          @picture_data = stream.read
        end

        def content_to_bytes
          pic_type = [PictureType.type(@picture_type)].pack('C*')
          encoded_descriptor = encode(@descriptor, null_terminated: true)
          merge(default_encoding_destination_byte, @mime_type, ZERO, pic_type, encoded_descriptor, @picture_data)
        end
      end

      module PictureType
        OTHER = 0x00
        PIXELS_32X32_FILE_ICON__PNG_ONLY = 0x01
        OTHER_FILE_ICON = 0x02
        COVER_FRONT = 0x03
        COVER_BACK = 0x04
        LEAFLET_PAGE = 0x05
        MEDIA = 0x06
        LEAD_ARTIST = 0x07
        ARTIST = 0x08
        CONDUCTOR = 0x09
        BAND = 0x0A
        COMPOSER = 0x0B
        LYRICIST = 0x0C
        RECORDING_LOCATION = 0x0D
        DURING_RECORDING = 0x0E
        DURING_PERFORMANCE = 0x0F
        VIDEO_SCREEN_CAPTURE = 0x10
        A_BRIGHT_COLORED_FISH = 0x11
        ILLUSTRATION = 0x12
        BAND_LOGOTYPE = 0x13
        PUBLISHER_LOGOTYPE = 0x14

        def self.type(type)
          return OTHER unless valid?(type)

          const_get(type)
        end

        def self.type_by_value(value)
          res = constants.find { |c| const_get(c) == value }
          res.nil? ? :OTHER : res
        end

        def self.valid?(type)
          const_get(type)
        rescue NameError
          false
        end
      end
    end
  end
end
