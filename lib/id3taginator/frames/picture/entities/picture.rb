# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Picture
      module Entities
        class Picture
          include Extensions::Comparable

          attr_accessor :mime_type, :picture_type, :descriptor, :picture_data

          # constructor
          #
          # @param mime_type [String] the mime type e.g. image/png. '-->' if the image is a reference, e.g. a URI
          # @param picture_type [Symbol, nil] the picture type, all types can be found in Picture::PictureType
          # @param descriptor [String] the description
          # @param picture_data [String] the picture data bytes represented as a String (str.bytes)
          def initialize(mime_type, picture_type, descriptor, picture_data)
            @mime_type = mime_type
            @picture_type = picture_type
            @descriptor = descriptor
            @picture_data = picture_data
          end

          def write_picture(file)
            File.open(file, 'wb') { |f| f.write(@picture_data) }
          end
        end
      end
    end
  end
end
