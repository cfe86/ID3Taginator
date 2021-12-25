# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Encryption::EncryptionMethodFrame do
  subject { Id3Taginator::Frames::Encryption::EncryptionMethodFrame }

  let!(:frame_id) { :ENCR }

  it 'reads encryption method frame successful' do
    val = "owner@mail.com\x00\x05some\nbinary\ndata"

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.owner_id).to eq('owner@mail.com')
    expect(frame.method_symbol).to eq(5)
    expect(frame.encryption_data).to eq("some\nbinary\ndata")
  end

  it 'converts the encryption method frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, 'owner@mail.com', 5, "some\nbinary\ndata")

    expect(in_frame.owner_id).to eq(parsed_frame.owner_id)
    expect(in_frame.method_symbol).to eq(parsed_frame.method_symbol)
    expect(in_frame.encryption_data).to eq(parsed_frame.encryption_data)
  end
end
