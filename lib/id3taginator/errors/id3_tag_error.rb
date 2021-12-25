# frozen_string_literal: true

module Id3Taginator
  module Errors
    class Id3TagError < StandardError

      def initialize(msg = nil)
        super
      end
    end
  end
end
