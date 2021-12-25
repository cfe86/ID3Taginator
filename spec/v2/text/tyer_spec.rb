# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Text::YearFrame do
  subject { Id3Taginator::Frames::Text::YearFrame }

  let!(:frame_id) { :TYER }

  it 'reads year frame successful' do
    val = encode('2021')

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.year).to eq('2021')
  end

  it 'converts the year frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, '2021')

    expect(in_frame.year).to eq(parsed_frame.year)
  end
end
