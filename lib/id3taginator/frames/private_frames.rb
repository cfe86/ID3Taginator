# frozen_string_literal: true

module Id3Taginator
  module Frames
    module PrivateFrames
      include Frames::Frameable

      # extracts the private frames (PRIV)
      #
      # @return [Array<Frames::Private::Entities::PrivateFrame>] returns the Private Frames
      def private_frames
        frame = find_frames(Private::PrivateFrame.frame_id(@major_version, @options))
        return [] if frame.nil? || frame.empty?

        frame.map { |f| Private::Entities::PrivateFrame.new(f.owner_id, f.private_data) }
      end

      # adds a private frame (PRIV)
      # Multiple ones can be added, as long as they have a different owner_id
      #
      # @param priv [Frames::Private::Entities::PrivateFrame] the private frame to add
      def private_frames=(priv)
        set_frame_fields_by_selector(Private::PrivateFrame, %i[@private_data],
                                     ->(f) { f.owner_id == priv.owner_id },
                                     priv.private_data, priv.owner_id)
      end

      alias add_private_frame private_frames=

      # removes a pictures for the specific owner_id
      #
      # @param owner_id [String] the owner_id
      def remove_private_frame(owner_id)
        @frames.delete_if do |f|
          f.identifier == Private::PrivateFrame.frame_id(@major_version, @options) && f.owner_id == owner_id
        end
      end
    end
  end
end
