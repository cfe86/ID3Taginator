# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Text::TitleFrame do
  subject { Id3Taginator::Frames::Text::TitleFrame }

  let!(:frame_id) { :TIT2 }

  it 'reads title frame successful' do
    val = encode('My Title')

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.title).to eq('My Title')
  end

  it 'converts the title frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, 'My Title')

    expect(in_frame.title).to eq(parsed_frame.title)
  end
end
