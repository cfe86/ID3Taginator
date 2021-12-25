# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Text::OriginalFilenameFrame do
  subject { Id3Taginator::Frames::Text::OriginalFilenameFrame }

  let!(:frame_id) { :TOFN }

  it 'reads original filename frame successful' do
    val = encode('My Filename')

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.original_filename).to eq('My Filename')
  end

  it 'converts the original filename frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, 'My Filename')

    expect(in_frame.original_filename).to eq(parsed_frame.original_filename)
  end
end
