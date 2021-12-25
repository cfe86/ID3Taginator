# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Encryption::AudioEncryptionFrame do
  subject { Id3Taginator::Frames::Encryption::AudioEncryptionFrame }

  let!(:frame_id) { :AENC }

  it 'reads audio encryption frame successful' do
    val = "owner@mail.com\x00\x10\x10\x10\x10some\nbinary\ndata"

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.owner_id).to eq('owner@mail.com')
    expect(frame.preview_start).to eq(4112)
    expect(frame.preview_length).to eq(4112)
    expect(frame.encryption_info).to eq("some\nbinary\ndata")
  end

  it 'converts the audio encryption frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, 'owner@mail.com', 4112, 4112, "some\nbinary\ndata")

    expect(in_frame.owner_id).to eq(parsed_frame.owner_id)
    expect(in_frame.preview_start).to eq(parsed_frame.preview_start)
    expect(in_frame.preview_length).to eq(parsed_frame.preview_length)
    expect(in_frame.encryption_info).to eq(parsed_frame.encryption_info)
  end
end
