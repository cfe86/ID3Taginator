# frozen_string_literal: true

module Id3Taginator
  module Frames
    module UfidFrames
      include Frames::Frameable

      # extracts the unique file identifier (UFID/UFI)
      #
      # @return [Array<Frames::Ufid::Entities::UfidInfo>] returns the Unique File Identifier
      def unique_file_identifiers
        frame = find_frames(Ufid::UniqueFileIdentifierFrame.frame_id(@major_version, @options))
        return [] if frame.nil? || frame.empty?

        frame.map { |f| Ufid::Entities::UfidInfo.new(f.owner_id, f.identifier) }
      end

      # adds a comment (UFID/UFI)
      # Multiple ones can be added, as long as they have different owner_id
      #
      # @param identifier [Frames::Ufid::Entities::UfidInfo] the unique file identifier to add
      def unique_file_identifiers=(identifier)
        set_frame_fields_by_selector(Ufid::UniqueFileIdentifierFrame, %i[@identifier],
                                     ->(f) { f.owner_id == identifier.owner_id },
                                     identifier.identifier, identifier.owner_id)
      end

      alias add_unique_file_identifier unique_file_identifiers=

      # removes a unique file identifier for the specific owner_id
      #
      # @param owner_id [String] the owner_id
      def remove_unique_file_identifiers(owner_id)
        @frames.delete_if do |f|
          f.identifier == Ufid::UniqueFileIdentifierFrame.frame_id(@major_version, @options) && f.owner_id == owner_id
        end
      end
    end
  end
end
