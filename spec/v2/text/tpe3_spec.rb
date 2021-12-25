# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Text::ConductorFrame do
  subject { Id3Taginator::Frames::Text::ConductorFrame }

  let!(:frame_id) { :TPE3 }

  it 'reads conductor frame successful' do
    val = encode('My Conductor')

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.conductor).to eq('My Conductor')
  end

  it 'converts the band information frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, 'My Conductor')

    expect(in_frame.conductor).to eq(parsed_frame.conductor)
  end
end
