# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Text
      class FileTypeFrame < Id3v2Frame
        include HasId

        frame_info :TFT, :TFLT, :TFLT

        attr_accessor :file_type

        # builds the writers frame
        #
        # @param file_type [Symbol, String] the file type, all FileTypes are in Text::FileTypes
        # @param options [Options::Options] options to use
        # @param id3_version [Integer] the id3 version to build the frame for
        #
        # @return [Id3v2Frame] the resulting id3v2 frame
        def self.build_frame(file_type = :MPEG_1_2_LAYER_III, options = nil, id3_version: 3)
          supported?('TFLT', id3_version, options)

          argument_not_nil(file_type, 'file_type')

          raise ArgumentError, "File_type isn't valid: #{file_type}" unless FileTypes.valid?(file_type)

          frame = new(frame_id(id3_version, options), 0, build_id3_flags(id3_version), '')
          frame.file_type = file_type
          frame
        end

        def process_content(content)
          @file_type = FileTypes.type_by_value(decode_using_encoding_byte(content))
        end

        def content_to_bytes
          content = FileTypes.type(@file_type)
          encode_and_add_encoding_byte(content)
        end
      end

      module FileTypes
        MPEG_AUDIO = 'MPG'
        MPEG_1_2_LAYER_I = '/1'
        MPEG_1_2_LAYER_II = '/2'
        MPEG_1_2_LAYER_III = '/3'
        MPEG_2_5 = '/2.5'
        AAC = '/AAC'
        VQF = 'VQF'
        PCM = 'PCM'

        def self.type(type)
          return MPEG_1_2_LAYER_III unless valid?(type)

          const_get(type)
        end

        def self.type_by_value(value)
          res = constants.find { |c| const_get(c) == value }
          res.nil? ? :MPEG_1_2_LAYER_III : res
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
