# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Text
      module Entities
        class UserInfo
          include Extensions::Comparable

          attr_accessor :description, :content

          # constructor
          #
          # @param description [String] the description
          # @param content [String] the content
          def initialize(description, content)
            @description = description
            @content = content
          end
        end
      end
    end
  end
end
