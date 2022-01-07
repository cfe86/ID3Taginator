# frozen_string_literal: true

module Id3Taginator
  module Frames
    module CustomFrames
      include Frames::Frameable

      # extracts a custom frame for the  given id
      #
      # @param frame_id [Symbol] the frame id
      #
      # @return [String, nil] returns the frame's content data bytes represented as a String (str.bytes)
      def custom_frame(frame_id)
        find_frame(frame_id)&.content
      end

      # adds a custom frame
      # Multiple ones can be added, the selector must be given to determine if a frame should be updated or added
      #
      # @param frame_id [Symbol] the frame id
      # @param content [String] the frame content's data bytes represented as a String (str.bytes)
      # @param selector_lambda [Proc] the lambda to find matching frames to update
      def add_custom_frame(frame_id, content, selector_lambda = nil)
        if selector_lambda.nil?
          existing_frame = find_frame(frame_id)
        else
          existing_frames = find_frames(frame_id)
          existing_frame = existing_frames&.find { |f| selector_lambda.call(f) }
        end

        unless existing_frame.nil?
          existing_frame.content = content
          return
        end

        new_frame = CustomFrame.build_frame(content, @options, id3_version: @major_version)
        new_frame.options = @options
        @frames << new_frame
      end

      # removes the frame with the given id or a specific one with the given selector
      #
      # @param frame_id [String] the frame id to remove
      # @param selector_lambda [Proc] the lambda to find matching frames to update
      def remove_custom_frame(frame_id, selector_lambda = nil)
        if selector_lambda.nil?
          @frames.delete_if { |f| f.frame_id == frame_id }
        else
          @frames.delete_if { |f| f.frame_id == frame_id && selector_lambda.call(f) }
        end
      end
    end
  end
end
