# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Text::EncodedByFrame do
  subject { Id3Taginator::Frames::Text::EncodedByFrame }

  let!(:frame_id) { :TENC }

  it 'reads album frame successful' do
    val = encode('My Encoder')

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.encoded_by).to eq('My Encoder')
  end

  it 'converts the album frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, 'My Encoder')

    expect(in_frame.encoded_by).to eq(parsed_frame.encoded_by)
  end
end
