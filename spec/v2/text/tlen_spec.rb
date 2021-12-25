# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Text::LengthFrame do
  subject { Id3Taginator::Frames::Text::LengthFrame }

  let!(:frame_id) { :TLEN }

  it 'reads length frame successful' do
    val = encode('1234567890')

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.length).to eq('1234567890')
  end

  it 'converts the length frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, '1234567890')

    expect(in_frame.length).to eq(parsed_frame.length)
  end
end
