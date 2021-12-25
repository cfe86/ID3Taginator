# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Ipl
      module Entities
        class InvolvedPerson
          include Extensions::Comparable

          attr_accessor :involvement, :involvee

          # constructor
          #
          # @param involvement [String] the involvement of the person
          # @param involvee [String] the involvee, e.g. the name of the person
          def initialize(involvement, involvee)
            @involvement = involvement
            @involvee = involvee
          end
        end
      end
    end
  end
end
