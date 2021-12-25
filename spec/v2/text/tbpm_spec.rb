# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Text::BPMFrame do
  subject { Id3Taginator::Frames::Text::BPMFrame }

  let!(:frame_id) { :TBPM }

  it 'reads bpm frame successful' do
    val = encode('128')

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.bpm).to eq('128')
  end

  it 'converts the bpm frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, '128')

    expect(in_frame.bpm).to eq(parsed_frame.bpm)
  end
end
