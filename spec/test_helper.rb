# frozen_string_literal: true

def hex_string_to_byte_stream(str)
  bytes = str.gsub(' ', '')
  b = bytes.scan(/../).map { |x| x.hex.chr }.join
  StringIO.new(b)
end

def hex_string_to_bytes(str)
  bytes = str.gsub(' ', '')
  bytes.scan(/../).map { |x| x.hex.chr }.join
end

def encode_str_to_hex(str, padding_to = nil)
  hex_str = str.unpack1('H*')
  return hex_str.ljust(padding_to, '0') unless padding_to.nil?

  hex_str
end

def encode(str, source_encoding = Encoding::UTF_8, dest_encoding = Encoding::UTF_16,
           add_encoding_byte: true, add_terminate_byte: true)
  res = str.encode(dest_encoding, source_encoding)
  if dest_encoding != Encoding::ISO8859_1
    bytes = res.bytes
    bytes << 0xFE << 0xFF if bytes.empty?
    bytes.unshift(0b1) if add_encoding_byte
    bytes << 0b0 << 0b0 if add_terminate_byte
    res = bytes.pack('C*')
  end

  res
end

def encoded_size_to_hex(num_bytes, padding_to = nil)
  res = num_bytes.to_s(16)
  return res.rjust(padding_to, '0') unless padding_to.nil?

  res
end

def test_frame_from_bytes(frame, frame_id, value)
  bytes = "#{encode_str_to_hex(frame_id.to_s, 8)}
           #{encoded_size_to_hex(value.bytes.length, 8)}
           00 00
           #{encode_str_to_hex(value)}"

  stream = hex_string_to_byte_stream(bytes)
  frame_id = stream.read(4)
  parsed_frame = frame.build_v3_frame(frame_id, stream, Id3Taginator::Options::Options.new)

  expect(parsed_frame.frame_id).to eq(frame.frame_id(3, Id3Taginator::Options::Options.new))

  parsed_frame
end

def test_frame_to_bytes(frame, *input)
  in_frame = frame.build_frame(*input, Id3Taginator::Options::Options.new)
  in_frame.options = Id3Taginator::Options::Options.new
  bytes = in_frame.to_bytes
  stream = StringIO.new(bytes)
  frame_id = stream.read(4)

  parsed_frame = frame.build_v3_frame(frame_id, stream, Id3Taginator::Options::Options.new)

  expect(in_frame.frame_id).to eq(parsed_frame.frame_id)
  [in_frame, parsed_frame]
end
