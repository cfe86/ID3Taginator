# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Text::EncoderFrame do
  subject { Id3Taginator::Frames::Text::EncoderFrame }

  let!(:frame_id) { :TSSE }

  it 'reads encoder frame successful' do
    val = encode('Encoder Lame 68.1 codec something')

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.encoder).to eq('Encoder Lame 68.1 codec something')
  end

  it 'converts the encoder frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, 'Encoder Lame 68.1 codec something')

    expect(in_frame.encoder).to eq(parsed_frame.encoder)
  end
end
