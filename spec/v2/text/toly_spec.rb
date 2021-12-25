# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Text::OriginalWritersFrame do
  subject { Id3Taginator::Frames::Text::OriginalWritersFrame }

  let!(:frame_id) { :TOLY }

  it 'reads original writers frame successful' do
    val = encode('Writer1/Writer num 2/Writer 3')

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.original_writers).to eq(['Writer1', 'Writer num 2', 'Writer 3'])
  end

  it 'converts the original writers frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, ['Writer1', 'Writer num 2', 'Writer 3'])

    expect(in_frame.original_writers).to eq(parsed_frame.original_writers)
  end
end
