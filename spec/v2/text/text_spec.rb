# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Text::WritersFrame do
  subject { Id3Taginator::Frames::Text::WritersFrame }

  let!(:frame_id) { :TEXT }

  it 'reads writers frame successful' do
    val = encode('Writer1/Writer num 2/Writer 3')

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.writers).to eq(['Writer1', 'Writer num 2', 'Writer 3'])
  end

  it 'converts the writers frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, ['Writer1', 'Writer num 2', 'Writer 3'])

    expect(in_frame.writers).to eq(parsed_frame.writers)
  end
end
