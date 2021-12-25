# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Grouping::GroupingFrame do
  subject { Id3Taginator::Frames::Grouping::GroupingFrame }

  let!(:frame_id) { :GRP1 }

  it 'reads grouping frame successful' do
    val = encode('Group1')

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.grouping).to eq('Group1')
  end

  it 'converts the grouping frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, 'Group1')

    expect(in_frame.grouping).to eq(parsed_frame.grouping)
  end
end
