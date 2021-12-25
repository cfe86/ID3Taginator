# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Text::SubtitleFrame do
  subject { Id3Taginator::Frames::Text::SubtitleFrame }

  let!(:frame_id) { :TIT3 }

  it 'reads subtitle frame successful' do
    val = encode('My Subtitle')

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.subtitle).to eq('My Subtitle')
  end

  it 'converts the subtitle frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, 'My Subtitle')

    expect(in_frame.subtitle).to eq(parsed_frame.subtitle)
  end
end
