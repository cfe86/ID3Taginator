# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Grouping::GroupIdentificationFrame do
  subject { Id3Taginator::Frames::Grouping::GroupIdentificationFrame }

  let!(:frame_id) { :GRID }

  it 'reads grid frame successful' do
    val = "owner@mail.com\x00\x05some\nbinary\ndata"

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.owner_id).to eq('owner@mail.com')
    expect(frame.group_symbol).to eq(5)
    expect(frame.group_dependant_data).to eq("some\nbinary\ndata")
  end

  it 'converts the grid frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, 'owner@mail.com', 5, "some\nbinary\ndata")

    expect(in_frame.owner_id).to eq(parsed_frame.owner_id)
    expect(in_frame.group_symbol).to eq(parsed_frame.group_symbol)
    expect(in_frame.group_dependant_data).to eq(parsed_frame.group_dependant_data)
  end
end
