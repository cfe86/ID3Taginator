# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Text::ISRCFrame do
  subject { Id3Taginator::Frames::Text::ISRCFrame }

  let!(:frame_id) { :TSRC }

  it 'reads isrc frame successful' do
    val = encode('123456789101')

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.isrc).to eq('123456789101')
  end

  it 'converts the isrc frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, '123456789101')

    expect(in_frame.isrc).to eq(parsed_frame.isrc)
  end
end
