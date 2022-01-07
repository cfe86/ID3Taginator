# frozen_string_literal: true

module Id3Taginator
  module Frames
    module GeoFrames
      include Frames::Frameable

      # extracts the general encapsulated objects (GEOB/GEO)
      #
      # @return [Array<Frames::Geo::Entities::EncapsulatedObject>] returns the general encapsulated objects
      def encapsulated_objects
        frame = find_frames(Geo::GeneralEncapsulatedObjectFrame.frame_id(@major_version, @options))
        return [] if frame.nil? || frame.empty?

        frame.map { |f| Geo::Entities::EncapsulatedObject.new(f.mime_type, f.filename, f.descriptor, f.object_data) }
      end

      # adds a general encapsulated object (GEOB/GEO)
      #
      # @param object [Frames::Geo::Entities::EncapsulatedObject] the object to add
      def encapsulated_object=(object)
        set_frame_fields_by_selector(Geo::GeneralEncapsulatedObjectFrame, %i[@mime_type @filename @descriptor
                                                                             @object_data],
                                     ->(f) { f.descriptor == object.descriptor },
                                     object.mime_type, object.filename, object.descriptor, object.object_data)
      end

      alias add_encapsulated_object encapsulated_object=

      # removes an encapsulated object for the specific descriptor
      #
      # @param descriptor [String] the descriptor
      def remove_encapsulated_object(descriptor)
        @frames.delete_if do |f|
          f.frame_id == Geo::GeneralEncapsulatedObjectFrame.frame_id(@major_version, @options) &&
            f.descriptor == descriptor
        end
      end
    end
  end
end
