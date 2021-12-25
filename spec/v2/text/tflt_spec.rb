# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Text::FileTypeFrame do
  subject { Id3Taginator::Frames::Text::FileTypeFrame }

  let!(:frame_id) { :TFLT }

  it 'reads file type frame successful' do
    val = encode('/3')

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.file_type).to eq(:MPEG_1_2_LAYER_III)
  end

  it 'converts the file type frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, :MPEG_1_2_LAYER_III)

    expect(in_frame.file_type).to eq(parsed_frame.file_type)
  end
end
