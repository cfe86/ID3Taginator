# frozen_string_literal: true

require_relative '../spec_helper'

RSpec.describe Id3Taginator do
  it 'it changes flags properly' do
    audio_bytes = '00010203 04050607 08091011'
    audio_file = Id3Taginator.build_by_bytes(audio_bytes, no_tag_parsing: true)

    tag = audio_file.create_id3v2_4_tag

    tag.footer = true
    expect(tag.footer?).to be_truthy
    tag.footer = false
    expect(tag.footer?).to be_falsey

    tag.unsynchronized = true
    expect(tag.unsynchronized?).to be_truthy
    tag.unsynchronized = false
    expect(tag.unsynchronized?).to be_falsey
  end
end
