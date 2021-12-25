# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Text::TrackNumberFrame do
  subject { Id3Taginator::Frames::Text::TrackNumberFrame }

  let!(:frame_id) { :TRCK }

  it 'reads track number frame successful' do
    val = encode('1/2')

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.track_number).to eq('1')
    expect(frame.total).to eq('2')
  end

  it 'reads track number without total frame successful' do
    val = encode('1')

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.track_number).to eq('1')
    expect(frame.total).to be_nil
  end

  it 'converts track number frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, '1', '2')

    expect(in_frame.track_number).to eq(parsed_frame.track_number)
    expect(in_frame.total).to eq(parsed_frame.total)
  end

  it 'converts track number without total frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, '1', nil)

    expect(in_frame.track_number).to eq(parsed_frame.track_number)
    expect(in_frame.total).to eq(parsed_frame.total)
  end
end
