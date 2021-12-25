# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Text::PublisherFrame do
  subject { Id3Taginator::Frames::Text::PublisherFrame }

  let!(:frame_id) { :TPUB }

  it 'reads publisher frame successful' do
    val = encode('My Publisher')

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.publisher).to eq('My Publisher')
  end

  it 'converts the publisher frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, 'My Publisher')

    expect(in_frame.publisher).to eq(parsed_frame.publisher)
  end
end
