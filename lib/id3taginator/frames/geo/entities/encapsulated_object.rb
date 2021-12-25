# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Geo
      module Entities
        class EncapsulatedObject
          include Extensions::Comparable

          attr_accessor :mime_type, :filename, :descriptor, :object_data

          # constructor
          #
          # @param mime_type [String] the mime type of the object e.g. image/png
          # @param filename [String] the filename
          # @param descriptor [String] the description
          # @param object_data [String] the object data bytes represented as a String (str.bytes)
          def initialize(mime_type, filename, descriptor, object_data)
            @mime_type = mime_type
            @filename = filename
            @descriptor = descriptor
            @object_data = object_data
          end
        end
      end
    end
  end
end
