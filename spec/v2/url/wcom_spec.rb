# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Url::CommercialUrlFrame do
  subject { Id3Taginator::Frames::Url::CommercialUrlFrame }

  let!(:frame_id) { :WCOM }

  it 'reads commercial information frame successful' do
    val = 'https://www.my-commercial-info.com'

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.url).to eq('https://www.my-commercial-info.com')
  end

  it 'converts the commercial information to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, 'https://www.my-commercial-info.com')

    expect(in_frame.url).to eq(parsed_frame.url)
  end
end
