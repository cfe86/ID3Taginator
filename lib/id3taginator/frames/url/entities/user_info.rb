# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Url
      module Entities
        class UserInfo
          include Extensions::Comparable

          attr_accessor :description, :url

          # constructor
          #
          # @param description [String] the description
          # @param url [String] the url
          def initialize(description, url)
            @description = description
            @url = url
          end
        end
      end
    end
  end
end
