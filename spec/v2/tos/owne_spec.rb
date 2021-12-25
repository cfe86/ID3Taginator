# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Tos::OwnershipFrame do
  subject { Id3Taginator::Frames::Tos::OwnershipFrame }

  let!(:frame_id) { :OWNE }

  it 'reads ownership frame successful' do
    val = "\x01$19.99\x0019700101#{encode('seller', add_encoding_byte: false, add_terminate_byte: false)}"

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.price_paid).to eq('$19.99')
    expect(frame.date_of_purchase).to eq('19700101')
    expect(frame.seller).to eq('seller')
  end

  it 'converts the ownership frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, '$19.99', '19700101', 'seller')

    expect(in_frame.price_paid).to eq(parsed_frame.price_paid)
    expect(in_frame.date_of_purchase).to eq(parsed_frame.date_of_purchase)
    expect(in_frame.seller).to eq(parsed_frame.seller)
  end
end
