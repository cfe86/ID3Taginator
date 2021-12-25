# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Text::RecordingDatesFrame do
  subject { Id3Taginator::Frames::Text::RecordingDatesFrame }

  let!(:frame_id) { :TRDA }

  it 'reads recording dates frame successful' do
    val = encode('date1, date 2,  4th to 7th')

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.recording_dates).to eq(['date1', 'date 2', '4th to 7th'])
  end

  it 'converts the recording dates frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, ['date1', 'date 2', '4th to 7th'])

    expect(in_frame.recording_dates).to eq(parsed_frame.recording_dates)
  end
end
