# frozen_string_literal: true

module Id3Taginator
  module Extensions
    module ArgumentCheck
      def self.included(base)
        base.extend(self)
      end

      # raises an ArgumentError if the given argument is nil
      #
      # @param arg [Object] the argument to check
      # @param arg_name [String] the argument name to use in the Error Message
      def argument_not_nil(arg, arg_name)
        raise ArgumentError, "#{arg_name} can't be nil." if arg.nil?
      end

      # raises an ArgumentError if the given argument no Symbol
      #
      # @param arg [Object] the argument to check
      # @param arg_name [String] the argument name to use in the Error Message
      def argument_sym(arg, arg_name)
        raise ArgumentError, "#{arg_name} must be sym." unless arg.is_a?(Symbol)
      end

      # raises an ArgumentError if the given argument is no Boolean
      #
      # @param arg [Object] the argument to check
      # @param arg_name [String] the argument name to use in the Error Message
      def argument_boolean(arg, arg_name)
        raise ArgumentError, "#{arg_name} must be boolean." unless !!arg == arg
      end

      # raises an ArgumentError if the given argument is no array or empty
      #
      # @param arg [Object] the argument to check
      # @param arg_name [String] the argument name to use in the Error Message
      def argument_not_empty(arg, arg_name)
        raise ArgumentError, "#{arg_name} can't be empty." if arg.nil? || (arg.is_a?(Array) && arg.empty?)
      end

      # raises an ArgumentError if the given argument has not the expected number of chars
      #
      # @param arg [String] the argument to check
      # @param arg_name [String] the argument name to use in the Error Message
      # @param num_chars [Integer] number of chars to check against
      def argument_exactly_chars(arg, arg_name, num_chars)
        raise ArgumentError, "#{arg_name} must have #{num_chars} characters." if arg.nil? || arg.length != num_chars
      end

      # rubocop:disable Style/GuardClause
      # raises an ArgumentError if the given argument has not the more than number of chars
      #
      # @param arg [String] the argument to check
      # @param arg_name [String] the argument name to use in the Error Message
      # @param num_chars [Integer] number of chars to check against
      def argument_less_than_chars(arg, arg_name, num_chars)
        if arg.nil? || arg.length > num_chars
          raise ArgumentError, "#{arg_name} must have less than #{num_chars} characters."
        end
      end

      # raises an ArgumentError if the given argument has not the more less number of chars
      #
      # @param arg [String] the argument to check
      # @param arg_name [String] the argument name to use in the Error Message
      # @param num_chars [Integer] number of chars to check against
      def argument_more_than_chars(arg, arg_name, num_chars)
        if arg.nil? || arg.length < num_chars
          raise ArgumentError, "#{arg_name} must have more than #{num_chars} characters."
        end
      end

      # raises an ArgumentError if the given arguments number of chars is not in the given range
      #
      # @param arg [String] the argument to check
      # @param arg_name [String] the argument name to use in the Error Message
      # @param bigger_than [Integer] string must have more than chars
      # @param smaller_than [Integer] string must have less than chars
      def argument_between_num(arg, arg_name, bigger_than, smaller_than)
        if arg.nil? || arg > smaller_than || arg < bigger_than
          raise ArgumentError, "#{arg_name} must have be between #{bigger_than} and #{smaller_than}."
        end
      end
      # rubocop:enable Style/GuardClause
    end
  end
end
