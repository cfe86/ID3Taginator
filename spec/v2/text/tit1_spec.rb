# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Text::ContentGroupDescriptionFrame do
  subject { Id3Taginator::Frames::Text::ContentGroupDescriptionFrame }

  let!(:frame_id) { :TIT1 }

  it 'reads content description frame successful' do
    val = encode('My content description')

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.content_description).to eq('My content description')
  end

  it 'converts the content description frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, 'My content description')

    expect(in_frame.content_description).to eq(parsed_frame.content_description)
  end
end
