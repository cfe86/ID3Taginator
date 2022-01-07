# frozen_string_literal: true

module Id3Taginator
  module Frames
    module CommentFrames
      include Frames::Frameable

      # extracts the comments (COMM/COM)
      #
      # @return [Array<Frames::Comment::Entities::Comment>] returns the Comments
      def comments
        frame = find_frames(Comment::CommentFrame.frame_id(@major_version, @options))
        return [] if frame.nil? || frame.empty?

        frame.map { |f| Comment::Entities::Comment.new(f.language, f.descriptor, f.text) }
      end

      # adds a comment (COMM/COM)
      # Multiple ones can be added, as long as they have different language/descriptor
      #
      # @param comment [Frames::Comment::Entities::Comment] the comment to set
      def comment=(comment)
        set_frame_fields_by_selector(Comment::CommentFrame, %i[@language @descriptor @text],
                                     ->(f) { f.language == comment.language && f.descriptor == comment.descriptor },
                                     comment.language, comment.descriptor, comment.text)
      end

      alias add_comment comment=

      # removes a comment for the specific language and descriptor
      #
      # @param language [String] the language
      # @param descriptor [String] the descriptor
      def remove_comment(language, descriptor)
        @frames.delete_if do |f|
          f.frame_id == Comment::CommentFrame.frame_id(@major_version, @options) && f.language == language &&
            f.descriptor == descriptor
        end
      end
    end
  end
end
