# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Text::TimeFrame do
  subject { Id3Taginator::Frames::Text::TimeFrame }

  let!(:frame_id) { :TIME }

  it 'reads time frame successful' do
    val = encode('0455')

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.hours).to eq('04')
    expect(frame.minutes).to eq('55')
  end

  it 'converts the time frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, '04', '55')

    expect(in_frame.hours).to eq(parsed_frame.hours)
    expect(in_frame.minutes).to eq(parsed_frame.minutes)
  end
end
