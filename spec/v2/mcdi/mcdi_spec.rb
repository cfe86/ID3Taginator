# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Mcdi::MusicCDIdentifierFrame do
  subject { Id3Taginator::Frames::Mcdi::MusicCDIdentifierFrame }

  let!(:frame_id) { :MCDI }

  it 'reads music cd identifier frame successful' do
    val = 'a CD toc'

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.cd_toc).to eq('a CD toc')
  end

  it 'converts the music cd identifier frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, 'a CD toc')

    expect(in_frame.cd_toc).to eq(parsed_frame.cd_toc)
  end
end
