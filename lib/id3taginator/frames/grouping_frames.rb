# frozen_string_literal: true

module Id3Taginator
  module Frames
    module GroupingFrames
      include Frames::Frameable

      # extracts the group information (GRID)
      #
      # @return [Array<Frames::Grouping::Entities::GroupIdentification>] returns the grouping information
      def group_identifications
        frame = find_frames(Grouping::GroupIdentificationFrame.frame_id(@major_version, @options))
        return [] if frame.nil? || frame.empty?

        frame.map do |f|
          Grouping::Entities::GroupIdentification.new(f.owner_id, f.group_symbol, f.group_dependant_data)
        end
      end

      # adds a group identification (GRID)
      #
      # @param group [Frames::Grouping::Entities::GroupIdentification] the grouping information to add
      def group_identifications=(group)
        set_frame_fields_by_selector(Grouping::GroupIdentificationFrame, %i[@group_symbol @group_dependant_data],
                                     ->(f) { f.owner_id == group.owner_id },
                                     group.owner_id, group.group_symbol, group.group_dependant_data)
      end

      alias add_group_identification group_identifications=

      # removes a group identification for the specific owner_id
      #
      # @param owner_id [String] the owner_id
      def remove_group_identification(owner_id)
        @frames.delete_if do |f|
          f.frame_id == Grouping::GroupIdentificationFrame.frame_id(@major_version, @options) &&
            f.owner_id == owner_id
        end
      end

      # extracts the Grouping (GRP1)
      #
      # @return [String, nil] returns the Grouping information
      def grouping
        find_frame(Grouping::GroupingFrame.frame_id(@major_version, @options))&.grouping
      end

      # sets the grouping (GRP1)
      #
      # @param grouping [String] the Grouping
      def grouping=(grouping)
        set_frame_fields(Grouping::GroupingFrame, [:@grouping], grouping)
      end

      # removes the grouping frame
      def remove_grouping
        @frames.delete_if { |f| f.frame_id == Grouping::GroupingFrame.frame_id(@major_version, @options) }
      end
    end
  end
end
