# frozen_string_literal: true

module Id3Taginator
  module Frames
    module HasId
      def self.included(base)
        base.extend(self)
      end

      # creates a class method to return the frame id depending on the major id3tag version
      # 3 and 4 return the 4 char Tag, 2 returns the version2 3 char Tag
      # Additionally, a method to check if the version is supported is provided.
      #
      # @param version2 [Symbol] the frame id for v2
      # @param version3 [Symbol] the frame id for v3
      # @param version4 [Symbol] the frame id for v4
      def frame_info(version2, version3, version4)
        define_singleton_method('frame_id') do |version = nil, options = nil|
          result = nil
          result = version3 if version.nil?

          result = version2 if version == 2
          result = version3 if version == 3
          result = version4 if version == 4

          result = version4 if version == 3 && options&.ignore_v23_frame_error && result.nil?
          result = version3 if version == 4 && options&.ignore_v24_frame_error && result.nil?

          result
        end
      end

      def supported?(frame_name, version, options)
        frame_id = frame_id(version)
        return true unless frame_id.nil?

        if version == 3 && options&.ignore_v23_frame_error
          v4_frame_id = frame_id(4)
          return true unless v4_frame_id.nil?
        end

        if version == 4 && options&.ignore_v24_frame_error
          v3_frame_id = frame_id(3)
          return true unless v3_frame_id.nil?
        end

        raise Errors::Id3TagError, "#{frame_name} not supported by Id3v2.#{version}"
      end
    end
  end
end
