# frozen_string_literal: true

module Id3Taginator
  module Frames
    module IplFrames
      include Frames::Frameable

      # extracts the involved people list (IPLS/IPL)
      #
      # @return [Array<Frames::Ipl::Entities::InvolvedPerson>] returns a list of involved people
      def involved_people
        frame = find_frame(Ipl::InvolvedPeopleFrame.frame_id(@major_version, @options))
        return [] if frame.nil?

        frame.involved_people
      end

      # sets the involved people (IPLS/IPL)
      #
      # @param involved_people [Array<Frames::Ipl::Entities::InvolvedPerson>] the involved people
      def involved_people=(involved_people)
        set_frame_fields(Ipl::InvolvedPeopleFrame, [:@involved_people], involved_people)
      end
    end
  end
end
