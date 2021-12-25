# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Private::PrivateFrame do
  subject { Id3Taginator::Frames::Private::PrivateFrame }

  let!(:frame_id) { :PRIV }

  it 'reads private frame frame successful' do
    val = "owner\x00private data"

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.owner_id).to eq('owner')
    expect(frame.private_data).to eq('private data')
  end

  it 'converts the private frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, 'owner', 'private data')

    expect(in_frame.owner_id).to eq(parsed_frame.owner_id)
    expect(in_frame.private_data).to eq(parsed_frame.private_data)
  end
end
