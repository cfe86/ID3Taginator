# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Ufid::UniqueFileIdentifierFrame do
  subject { Id3Taginator::Frames::Ufid::UniqueFileIdentifierFrame }

  let!(:frame_id) { :UFID }

  it 'reads ufid frame frame successful' do
    val = "owner\x00unique identifier bytes"

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.owner_id).to eq('owner')
    expect(frame.identifier).to eq('unique identifier bytes')
  end

  it 'converts the ufid frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, 'owner', 'unique identifier bytes')

    expect(in_frame.owner_id).to eq(parsed_frame.owner_id)
    expect(in_frame.identifier).to eq(parsed_frame.identifier)
  end
end
