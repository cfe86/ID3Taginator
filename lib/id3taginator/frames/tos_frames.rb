# frozen_string_literal: true

module Id3Taginator
  module Frames
    module ToSFrames
      include Frames::Frameable

      # extracts the terms of use frame (USER)
      #
      # @return [Frames::Tos::Entities::TermsOfUse, nil] returns the ToU Frame
      def terms_of_use
        frame = find_frame(Tos::TermsOfUseFrame.frame_id(@major_version, @options))

        Frames::Tos::Entities::TermsOfUse.new(frame&.language, frame&.text)
      end

      # sets the terms of use frame (USER)
      #
      # @param tou [Frames::Tos::Entities::TermsOfUse] the ToU
      def terms_of_use=(tou)
        set_frame_fields(Tos::TermsOfUseFrame, %i[@language @text], tou.language, tou.text)
      end

      # extracts the ownership frame (OWNE)
      #
      # @return [Frames::Tos::Entities::Ownership, nil] returns the Ownership Frame
      def ownership
        frame = find_frame(Tos::OwnershipFrame.frame_id(@major_version, @options))

        Frames::Tos::Entities::Ownership.new(frame&.price_paid, frame&.date_of_purchase, frame&.seller)
      end

      # sets the ownership frame (OWNE)
      #
      # @param ownership [Frames::Tos::Entities::Ownership] the Ownership
      def ownership=(ownership)
        set_frame_fields(Tos::OwnershipFrame, %i[@price_paid @date_of_purchase @seller],
                         ownership.price_paid, ownership.date_of_purchase, ownership.seller)
      end
    end
  end
end
