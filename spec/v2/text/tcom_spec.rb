# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Text::ComposerFrame do
  subject { Id3Taginator::Frames::Text::ComposerFrame }

  let!(:frame_id) { :TCOM }

  it 'reads composer frame successful' do
    val = encode('My Composer1/My Composer2/My Composer3')

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.composers).to eq(['My Composer1', 'My Composer2', 'My Composer3'])
  end

  it 'converts the composer frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, ['My Composer1', 'My Composer2', 'My Composer3'])

    expect(in_frame.composers).to eq(parsed_frame.composers)
  end
end
