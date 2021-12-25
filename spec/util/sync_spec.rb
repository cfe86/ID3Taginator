# frozen_string_literal: true

require_relative '../spec_helper'

RSpec.describe Id3Taginator::Util::SyncUtil do
  it 'adds synchronisation' do
    bytes = "\x00\x00\xab\xff\x00\xab\xcd\xff\x00\x00\xff\xff\xe0\xff\xe0\xff"
    expected = "\x00\x00\xab\xff\x00\x00\xab\xcd\xff\x00\x00\x00\xff\x00\xff\x00\xe0\xff\x00\xe0\xff\x00"
    res = Id3Taginator::Util::SyncUtil.add_synchronization(StringIO.new(bytes))

    expect(res.bytes).to eq(expected.bytes)
  end

  it 'undo synchronisation' do
    bytes = "\x00\x00\xab\xff\x00\x00\xab\xcd\xff\x00\x00\x00\xff\x00\xff\x00\xe0\xff\x00\xe0\xff\x00"
    expected = "\x00\x00\xab\xff\x00\xab\xcd\xff\x00\x00\xff\xff\xe0\xff\xe0\xff"
    res = Id3Taginator::Util::SyncUtil.undo_synchronization(StringIO.new(bytes))

    expect(res.bytes).to eq(expected.bytes)
  end
end
