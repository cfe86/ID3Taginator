# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Url::OfficialFileWebpageFrame do
  subject { Id3Taginator::Frames::Url::OfficialFileWebpageFrame }

  let!(:frame_id) { :WOAF }

  it 'reads file webpage url frame successful' do
    val = 'https://www.my-file-info.com'

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.url).to eq('https://www.my-file-info.com')
  end

  it 'converts the file webpage url frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, 'https://www.my-file-info.com')

    expect(in_frame.url).to eq(parsed_frame.url)
  end
end
