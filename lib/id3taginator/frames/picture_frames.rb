# frozen_string_literal: true

module Id3Taginator
  module Frames
    module PictureFrames
      include Frames::Frameable

      # extracts the pictures (APIC/PIC)
      #
      # @return [Array<Frames::Picture::Entities::Picture>] returns the Pictures
      def pictures
        frame = find_frames(Picture::PictureFrame.frame_id(@major_version, @options))
        return [] if frame.nil? || frame.empty?

        frame.map { |f| Picture::Entities::Picture.new(f.mime_type, f.picture_type, f.descriptor, f.picture_data) }
      end

      # adds a pictures (APIC/PIC)
      # Multiple ones can be added, as long as they have a different picture_type
      #
      # @param picture [Frames::Picture::Entities::Picture] the picture to add
      def pictures=(picture)
        if picture.picture_type == Frames::Picture::PictureType::PIXELS_32X32_FILE_ICON__PNG_ONLY ||
           picture.picture_type == Frames::Picture::PictureType::OTHER_FILE_ICON
          frames = pictures
          if frames.any? { |f| f.picture_type == picture.picture_type }
            raise Errors::Id3TagError, "Only one frame of type #{picture.picture_type} is allowed"
          end
        end

        set_frame_fields_by_selector(Picture::PictureFrame, %i[@mime_type @picture_type @descriptor @picture_data],
                                     lambda { |f|
                                       f.picture_type == picture.picture_type &&
                                         f.descriptor == picture.descriptor
                                     },
                                     picture.mime_type, picture.picture_type, picture.descriptor, picture.picture_data)
      end

      alias add_picture pictures=

      # removes a pictures for the specific descriptor
      #
      # @param descriptor [String] the descriptor
      def remove_picture(descriptor)
        @frames.delete_if do |f|
          f.frame_id == Picture::PictureFrame.frame_id(@major_version, @options) && f.descriptor == descriptor
        end
      end
    end
  end
end
