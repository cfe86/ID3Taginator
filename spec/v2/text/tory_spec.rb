# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Text::OriginalReleaseYearFrame do
  subject { Id3Taginator::Frames::Text::OriginalReleaseYearFrame }

  let!(:frame_id) { :TORY }

  it 'reads original release year frame successful' do
    val = encode('2005')

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.original_release_year).to eq('2005')
  end

  it 'converts the original release year frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, '2005')

    expect(in_frame.original_release_year).to eq(parsed_frame.original_release_year)
  end
end
