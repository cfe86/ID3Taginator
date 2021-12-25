# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Frameable
      # raises an error that the given frame is not available for the id3v2 version
      def unsupported_frame(frame_name, version)
        raise Errors::Id3TagError, "#{frame_name} is not supported in Id3v2.#{version}"
      end

      # finds the frame with the given frame id, or nil of not present
      #
      # @param frame_id [Symbol] the frame id to search for
      #
      # @return [Id3v2Frame, nil] the found frame or nil, if not present
      def find_frame(frame_id)
        @frames.find { |f| f.frame_id == frame_id }
      end

      # finds the frames with the given frame id, or nil of not present
      #
      # @param frame_id [Symbol] the frame id to search for
      #
      # @return [Array<Id3v2Frame>, nil] the found frames or nil, if not present
      def find_frames(frame_id)
        @frames.select { |f| f.frame_id == frame_id }
      end

      # sets the given arguments to the appropriate field of the given frame. The field order must be same as the
      # argument order. So e.g. fields a, b, c and arguments a_v, b_v, c_v will lead to a = a_v, b = b_v and c = c_v
      # If the frame already exists, it will be updated. Otherwise it will be created.
      #
      # @param frame [Id3v2Frame] the frame to set the fields too
      # @param fields [Array<String>] the fields to set, must be in the same order as the arguments
      # @param arguments [Array<Object>] the values to set to the fields
      def set_frame_fields(frame, fields, *arguments)
        existing_frame = find_frame(frame.frame_id(@major_version))
        unless existing_frame.nil?
          fields.each_with_index { |field, index| existing_frame.instance_variable_set(field, arguments[index]) }
          return
        end

        new_frame = frame.build_frame(*arguments, @options, id3_version: @major_version)
        new_frame.options = @options
        @frames << new_frame
      end

      # sets the given arguments to the appropriate field of the given frame(s). The field order must be same as the
      # argument order. So e.g. fields a, b, c and arguments a_v, b_v, c_v will lead to a = a_v, b = b_v and c = c_v
      # If the frame already exists, it will be updated. Otherwise it will be created.
      # The field will be determined by the given selector_lambda, so e.g.
      # ->(f) { f.descriptor == 'a value' }
      # will be updated, if the frame.descriptor is 'a value'
      #
      # @param frame [Id3v2Frame] the frame to set the fields too
      # @param fields [Array<String>] the fields to set, must be in the same order as the arguments
      # @param selector_lambda [Proc] the lambda to find matching frames to update
      # @param arguments [Array<Object>] the values to set to the fields
      def set_frame_fields_by_selector(frame, fields, selector_lambda, *arguments)
        existing_frames = find_frames(frame.frame_id(@major_version))

        existing_frame = existing_frames&.find { |f| selector_lambda.call(f) }

        unless existing_frame.nil?
          fields.each_with_index { |field, index| existing_frame.instance_variable_set(field, arguments[index]) }
          return
        end

        new_frame = frame.build_frame(*arguments, id3_version: @major_version)
        new_frame.options = @options
        @frames << new_frame
      end
    end
  end
end
