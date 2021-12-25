# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Text::FileOwnerFrame do
  subject { Id3Taginator::Frames::Text::FileOwnerFrame }

  let!(:frame_id) { :TOWN }

  it 'reads file owner frame successful' do
    val = encode('File Owner')

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.file_owner).to eq('File Owner')
  end

  it 'converts the file owner frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, 'File Owner')

    expect(in_frame.file_owner).to eq(parsed_frame.file_owner)
  end
end
