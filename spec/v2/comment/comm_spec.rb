# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Comment::CommentFrame do
  subject { Id3Taginator::Frames::Comment::CommentFrame }

  let!(:frame_id) { :COMM }

  it 'reads comment frame successful' do
    val = "\x01eng#{encode('descriptor', add_encoding_byte: false)}"\
          "#{encode("some\ntext\ncomment", add_encoding_byte: false, add_terminate_byte: false)}"
    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.language).to eq('eng')
    expect(frame.descriptor).to eq('descriptor')
    expect(frame.text).to eq("some\ntext\ncomment")
  end

  it 'reads comment without descriptor frame successful' do
    val = "\x01eng#{encode('', add_encoding_byte: false)}" \
    "#{encode("some\ntext\ncomment", add_encoding_byte: false, add_terminate_byte: false)}"

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.language).to eq('eng')
    expect(frame.descriptor).to eq('')
    expect(frame.text).to eq("some\ntext\ncomment")
  end

  it 'converts the comment frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, 'eng', 'descriptor', "some\ntext\ncomment")

    expect(in_frame.language).to eq(parsed_frame.language)
    expect(in_frame.descriptor).to eq(parsed_frame.descriptor)
    expect(in_frame.text).to eq(parsed_frame.text)
  end

  it 'converts the comment without descriptor frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, 'eng', nil, "some\ntext\ncomment")

    expect(in_frame.language).to eq(parsed_frame.language)
    expect(in_frame.descriptor).to eq(parsed_frame.descriptor)
    expect(in_frame.text).to eq(parsed_frame.text)
  end
end
