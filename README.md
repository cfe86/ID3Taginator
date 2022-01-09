# Id3taginator

- [Introduction](#introduction)
- [Installation](#installation)
- [Implemented Frames](#implemented-frames)
- [Usage](#usage)
    * [Read Tags](#read-tags)
    * [Modify Tag](#modify-tag)
        + [Remove Tag](#remove-tag)
        + [Modify existing Frame](#modify-existing-frame)
        + [Create new Tag](#create-new-tag)
            - [What is the difference?](#what-is-the-difference-)
    * [Write Audio File with modified Tags](#write-audio-file-with-modified-tags)
    * [Options](#options)
        - [default_encode_dest](#default-encode-dest)
        - [default_decode_dest](#default-decode-dest)
        - [padding_bytes](#padding-bytes)
        - [ignore_v23_frame_error](#ignore-v23-frame-error)
        - [ignore_v24_frame_error](#ignore-v24-frame-error)
        - [add_size_frame](#add-size-frame)
        + [How to set Options](#how-to-set-options)
    * [Create Entities](#create-entities)
    * [Custom Frames](#custom-frames)
- [Development](#development)
- [Contributing](#contributing)
- [License](#license)
- [Code of Conduct](#code-of-conduct)

## Introduction

Id3Taginator is a ID3v1, ID3v2.2/3/4 [tag reader](https://en.wikipedia.org/wiki/ID3) and writer fully written in Ruby and does not
rely on TagLib or any other 3rd party library to read/write iD3 Tags. It aims to offer a simple
way to read and write ID3Tags.
It follows the specifications as seen here:
* ID3v1 - https://id3.org/ID3v1
* ID3v2.2 - https://id3.org/id3v2-00
* Id3v2.3 - https://id3.org/id3v2.3.0
* Id3v2.4 - https://id3.org/id3v2.4.0-structure / https://id3.org/id3v2.4.0-frames

It can write ID3v1 and ID3v2 to the same file. For ID3v2 only 1 version can be used. 
It is recommended to stick to ID3v2.3, because for now, it seems to be the most supported version.

## Installation

from [rubygems](https://rubygems.org/gems/id3taginator)

```shell
gem 'id3taginator'
```
or from the sources using
```shell
gem build id3taginator.gemspec
```
and then execute
```shell
gem install id3taginator-x.x.x.gem
```

## Implemented Frames

The following frames are implemented and fully supported. Not implemented frames can still be added by using a custom frame.
See more about custom frames in the _Usage_ part. Most Frames are self explaining. For other documentation about the frames and their meaning,
please check the documentation - [ID3v1](https://id3.org/ID3v1), [ID3v2.2](https://id3.org/id3v2-00), 
[Id3v2.3](https://id3.org/id3v2.3.0), [Id3v2.4](https://id3.org/id3v2.4.0-structure)

**Hint:** If a frame is currently not implemented, it can still be read and written using Custom Frames.
In this case, if an MP3 file is written that contains a not implemented frame, that frame will simply be saved as a 
Custom Frame, can be modified as such and will be written as it was once the file is saved.

| Implemented | Frame     |   Description                                       | ID3v2.2 | ID3v2.3 | ID3v2.4 |
| :---------: | -----     | --------------------------------------------------- | :-----: | :-----: | :-----: |
| x           | AENC/CRA  | Audio encryption                                    | x       | x       | x       |
| x           | APIC/PIC  | Attached picture                                    | x       | x       | x       |
|             | ASPI      | Audio seek point index                              |         |         | x       |
| x           | COMM/COM  | Comments                                            | x       | x       | x       |
|             | COMR      | Commercial frame                                    |         | x       | x       |
|             | CRM       | Encrypted meta frame                                | x       |         |         |
| x           | ENCR      | Encryption method registration                      |         | x       | x       |
|             | EQUA/EQU  | Equalization                                        | x       | x       |         |
|             | EQU2      | Equalization (2)                                    |         |         | x       |
|             | ETCO/ETC  | Event timing codes                                  | x       | x       | x       |
| x           | GEOB/GEO  | General encapsulated object                         | x       | x       | x       |
| x           | GRID      | Group identification registration                   |         | x       | x       |
| x           | GRP1      | iTunes Grouping                                     |         | x       | x       |
| x           | IPLS/PLS  | Involved people list                                | x       | x       | x       |
|             | LINK/LNK  | Linked information                                  | x       | x       | x       |
| x           | MCDI/MCI  | Music CD identifier                                 | x       | x       | x       |
|             | MLLT/MLL  | MPEG location lookup table                          | x       | x       | x       |
| x           | PCNT/CNT  | Play counter                                        | x       | x       | x       |
| x           | POPM/POP  | Popularimeter                                       | x       | x       | x       |
|             | POSS      | Position synchronisation frame                      |         | x       | x       |
| x           | RBUF/BUF  | Recommended buffer size                             | x       | x       | x       |
|             | RVAD/RVA  | Relative volume adjustment                          | x       | x       |         |
|             | RVA2      | Relative volume adjustment (2)                      |         |         | x       |
|             | RVRB/REV  | Reverb                                              | x       | x       | x       |
|             | SEEK      | Seek frame                                          |         |         | x       |
|             | SIGN      | Signature frame                                     |         |         | x       |
|             | SYLT/SLT  | Synchronized lyric/text                             | x       | x       | x       |
|             | SYTC/STC  | Synchronized tempo codes                            | x       | x       | x       |
| x           | OWNE      | Ownership frame                                     |         | x       | x       |
| x           | PRIV      | Private frame                                       |         | x       | x       |
| x           | TALB/TAL  | Album/Movie/Show title                              | x       | x       | x       |
| x           | TBPM/TBP  | BPM (beats per minute)                              | x       | x       | x       |
| x           | TCOM/TCM  | Composer                                            | x       | x       | x       |
| x           | TCON/TCO  | Content type                                        | x       | x       | x       |
| x           | TCOP/TCR  | Copyright message                                   | x       | x       | x       |
| x           | TDAT/TDA  | Date                                                | x       | x       | x       |
|             | TDEN      | Encoding time                                       |         |         | x       |
| x           | TDLY/TDY  | Playlist delay                                      | x       | x       | x       |
|             | TDOR      | Original release time                               |         |         | x       |
|             | TDRC      | Recording time                                      |         |         | x       |
|             | TDRL      | Release time                                        |         |         | x       |
|             | TDTG      | Tagging time                                        |         |         | x       |
| x           | TENC/TEN  | Encoded by                                          | x       | x       | x       |
| x           | TEXT/TXT  | Lyricist/Text writer                                | x       | x       | x       |
| x           | TFLT/TFT  | File type                                           | x       | x       | x       |
| x           | TIME/TIM  | Time                                                | x       | x       | x       |
| x           | TIT1/TT1  | Content group description                           | x       | x       | x       |
| x           | TIT2/TT2  | Title/songname/content description                  | x       | x       | x       |
| x           | TIT3/TT3  | Subtitle/Description refinement                     | x       | x       | x       |
| x           | TKEY/TKE  | Initial key                                         | x       | x       | x       |
| x           | TLAN/TLA  | Language(s)                                         | x       | x       | x       |
| x           | TLEN/TLE  | Length                                              | x       | x       | x       |
|             | TMCL      | Musician credits list                               |         |         | x       |
| x           | TMED/TMT  | Media type                                          | x       | x       | x       |
|             | TMOO      | Mood                                                |         |         | x       |
| x           | TOAL/TOT  | Original album/movie/show title                     | x       | x       | x       |
| x           | TOFN/TOF  | Original filename                                   | x       | x       | x       |
| x           | TOLY/TOL  | Original lyricist(s)/text writer(s)                 | x       | x       | x       |
| x           | TOPE/TOA  | Original artist(s)/performer(s)                     | x       | x       | x       |
| x           | TORY/TOR  | Original release year                               | x       | x       | x       |
| x           | TOWN      | File owner/licensee                                 |         | x       | x       |
| x           | TPE1/TP1  | Lead performer(s)/Soloist(s)                        | x       | x       | x       |
| x           | TPE2/TP2  | Band/orchestra/accompaniment                        | x       | x       | x       |
| x           | TPE3/TP3  | Conductor/performer refinement                      | x       | x       | x       |
| x           | TPE4/TP4  | Interpreted, remixed, or otherwise modified by      | x       | x       | x       |
| x           | TPOS/TPA  | Part of a set                                       | x       | x       | x       |
|             | TPRO      | Produced notice                                     |         |         | x       |
| x           | TPUB/TPB  | Publisher                                           | x       | x       | x       |
| x           | TRCK/TRK  | Track number/Position in set                        | x       | x       | x       |
| x           | TRDA/TRD  | Recording dates                                     | x       | x       | x       |
| x           | TRSN      | Internet radio station name                         |         | x       | x       |
|             | TRSO      | Internet radio station owner                        |         |         | x       |
| x           | TSIZ/TSI  | Size                                                | x       | x       |         |
| x           | TSOA      | Album sort order                                    |         |         | x       |
| x           | TSOP      | Performer sort order                                |         |         | x       |
| x           | TSOT      | Title sort order                                    |         |         | x       |
| x           | TSRC/TRC  | ISRC (international standard recording code)        | x       | x       | x       |
| x           | TSSE/TSS  | Software/Hardware and settings used for encoding    | x       | x       | x       |
|             | TSST      | Set subtitle                                        |         |         | x       |
| x           | TXXX/TXX  | User defined text information frame                 | x       | x       | x       |
| x           | TYER/TYE  | Year                                                | x       | x       | x       |
| x           | UFID/UFI  | Unique file identifier                              | x       | x       | x       |
| x           | USER      | Terms of use                                        |         | x       | x       |
| x           | USLT/ULT  | Unsynchronized lyric/text transcription             | x       | x       | x       |
| x           | WCOM/WCM  | Commercial information                              | x       | x       | x       |
| x           | WCOP/WCP  | Copyright/Legal information                         | x       | x       | x       |
| x           | WOAF/WAF  | Official audio file webpage                         | x       | x       | x       |
| x           | WOAR/WAR  | Official artist/performer webpage                   | x       | x       | x       |
| x           | WOAS/WAS  | Official audio source webpage                       | x       | x       | x       |
| x           | WORS      | Official internet radio station homepage            |         | x       | x       |
| x           | WPAY      | Payment                                             |         | x       | x       |
| x           | WPUB/WPB  | Publishers official webpage                         | x       | x       | x       |
| x           | WXXX/WXX  | User defined URL link frame                         | x       | x       | x       |

## Usage

The usage is pretty straight forward. The audio file will be read and parsed, and provides access to all 
available frames, allows to add or remove frames and finally, write the file.

To modify and/or read a tag, simply create an audio file:
```ruby
audio_file =  Id3Taginator.build_by_path('path/to/audio_file')
```
this will automatically parse the ID3 tags, if an ID3tag is present.

### Read Tags
```ruby
v1_tag = audio_file.id3v1_tag
v1_tag.title # => 'ID3v1 Title'
v1_tag.artist # => 'ID3v1 Artist'
v1_tag.album # => 'ID3v1 Album'

# this can either be a ID3v2.2, ID3v2.3 or ID3v2.4 tag
v2_tag = audio_file.id3v2_tag
v2_tag.version # => 2.3.0
v2_tag.title # => 'ID3v2 Title'
v2_tag.artists # => ['ID3v2 Artist1', 'ID3v2 Artist2']
v2_tag.album # => 'ID3v2 Album'
```

### Modify Tag

existing tags can either be modified, or a new tag can be created, or an existing one removed.

#### Remove Tag
```ruby
audio_file.remove_id3v1_tag
audio_file.remove_id3v2_tag
```
will remove the ID3vX tags.

#### Modify existing Frame

There are already methods defined to modify a frame. Each frame has one. A Frame that is only allowed once, has only one Getter and one Setter.
If a Frame is present, the Setter will update the existing Frame. If no Frame it is present, it will create a new Frame.

If the Frame can be present multiple times, the Setter Method will update the existing frame, if a specific field with the unique identifier is the same (see the ruby doc to find out which field is the unique field).
In those cases, the Setter is `field=` or alternatively `add_field`, e.g. `comment=` and `add_comment(...)` are the same.
If no Frame with the unique field is present, a new Frame will be added.

The Getter methods will return nil if the Frame is not present or en empty array, if the frame is not present, but the result is an array.

```ruby
v1_tag = audio_file.id3v1_tag
v1_tag.title = 'My new Title'
v1_tag.title # => 'My new Title'
v1_tag.title = nil
v1_tag.title # => nil

v2_tag = audio_file.id3v2_tag
v2_tag.title = 'My new Title'
v2_tag.title # => 'My new Title'
v2_tag.remove_title
v2_tag.title # => nil

v2_tag.languages # => []
v2_tag.languages = %w[eng ger]
v2_tag.languages # ['eng', 'ger']
v2_tag.languages = %w[eng]
v2_tag.languages # ['eng']
v2_tag.remove_languages
v2_tag.languages # => []

v2_tag.comments # => []
v2_tag.add_comment(Id3Taginator.create_comment('eng', 'my descriptor', 'my comment'))
v2_tag.comments # => [Comment('eng', 'my descriptor', 'my comment')]
v2_tag.add_comment(Id3Taginator.create_comment('eng', 'another descriptor', 'my other comment'))
v2_tag.comments # => [Comment('eng', 'my descriptor', 'my comment'), Comment('eng', 'another descriptor', 'my other comment')]
v2_tag.add_comment(Id3Taginator.create_comment('eng', 'my descriptor', 'my modified comment'))
# descriptor and language are already present, so it will update the comment instead of creating a new one
v2_tag.comments # => [Comment('eng', 'my descriptor', 'my modified comment'), Comment('eng', 'another descriptor', 'my other comment')]

v2_tag.remove_comment('eng', 'my descriptor')
v2_tag.comments # => [Comment('eng', 'another descriptor', 'my other comment')]
```

#### Create new Tag

If no tag is present, or a new one should be created, a few simple methods are present:
```ruby
audio_file.create_id3v1_tag # => the id3v1_tag
audio_file.create_id3v2_2_tag # => the id3v22_tag
audio_file.create_id3v2_3_tag # => the id3v23_tag
audio_file.create_id3v2_4_tag # => the id3v24_tag
```
As mentioned before, it is recommended to use ID3v2.3, because it seems to be the most supported for version.

##### What is the difference?

ID3v2.2 is the oldest ID3v2 tag, and for example only uses 3 characters for the Frame ID and offers far less Frames as the successors.
It should be avoided, because it is kinda outdated.

ID3v2.3 and ID3v2.4 are very similar. ID3v2.4 added a few more frames, and allows 2 more encodings in comparison to ID3v2.3,
but most of the new added frames or changes are not game breaking and most probably not used by most people.
Some of the useful new frames like `Album Sort Order` or `Title Sort Order` are officially not part of ID3v2.3, but most players
will interpret them nevertheless, as long as they are present. Per default ID3Taginator allows to add those ID3v2.4 only frames even to
ID3v2.3 Tags.

### Write Audio File with modified Tags

Once a file is modified, it must be written to save the changes. To do this, Id3Taginator provides to 2 methods:
```ruby
audio_file.write_audio_file('path/to/new/file')
```
Which writes the modified file to the specified path. The audio data will be cached, so the file can be written to the same
path that is used to read the MP3 file, essentially overwriting it.

The other alternative is to write the result to a byte array represented as a String:

```ruby
audio_file.audio_file_to_bytes
```
This will return a byte array represented as a String (str.bytes) with the modified audio file, and the decision how to 
handle it, is completely yours.

### Options

The following options are available:
##### default_encode_dest
This is the encoding that should be used to encode the data if applicable. For example most Text Frames are encoded
and the encoding byte is prefixed to the encoded data.

**Default** is `UTF-16`

##### default_decode_dest
This is more or less only for internal use and doesn't affect the written tag. This encoding is used to decode the tag if an encoding
is applied and later on, when the tag is written the `default_encode_dest` is used again.

**Default** is `UTF-8`

##### padding_bytes
After the last Frame is written, optionally padding null bytes can be written. Padding bytes can for example be used to add additionally information,
e.g. an `ID3 Footer` without rewriting the whole tag.

**Default** is `20`

##### ignore_v23_frame_error

Some Frames are available for ID3v2.4 but not for ID3v2.3, for example the Sort Order frames like TSOT.
But some application still interpret them correctly, hence they can be used in ID3v2.3 even if they are not 
in the specifications. When this flag is true, no error will be raised if an invalid Frame should be added to the Tag.
In those cases it is for example possible to add an ID3v2.4 only Tag to an ID3v2.3 Tag.

**Default** is `true`

##### ignore_v24_frame_error

Same as `ignore_v23_frame_error` just for ID3v2.4 Tag.

**Default** is `true`

##### add_size_frame

ID3v2.3 has a size (TSIZ) frame that contains the file size in bytes without ID3v2 Tag size. When this flag is true
this Frame will be added automatically if it is not present.

Note: In ID3v2.4 this Frame was removed. So in order to use this flag for ID3v2.4 Tags, the flag `ignore_v24_frame_error`
must be `true` too.

**Default** is `false`

#### How to set Options

Options can be set on a global level, then those options will be applied to all Audio Files that are created,
or the option is only applied to one Audio File.

To define global options, simply create an `Id3Taginator` instance and apply the options:
```ruby
id3taginator = Id3Taginator.global_options
  .default_encode_for_destination(Encoding::UTF_16)
  .default_decode_for_destination(Encoding::UTF_8)
  .tag_padding(42)
  .ignore_v23_frame_error(true)
  .ignore_v24_frame_error(false)
  .add_size_frame(true)

audio_file = id3taginator.build_by_path('path/to/file')
# => options are applied
another_audio_file = id3taginator.build_by_path('path/to/another/file')
# => options are applied too
```
if options should be applied to one audio file, create the file and apply the options directly to this file
```ruby
audio_file = Id3Taginator.build_by_path('path/to/file')
audio_file.default_encode_for_destination(Encoding::UTF_16)
          .default_decode_for_destination(Encoding::UTF_8)
          .tag_padding(42)
          .ignore_v23_frame_error(true)
          .ignore_v24_frame_error(false)
          .add_size_frame(true)
```
Here, the options are only applied to this Audio File instance. All other created instance use the default options.

### Create Entities

Some Setter such as `copyright=` or `add_picture` require an Entity Instance as an argument. All arguments can be created 
like this

```ruby
Id3Taginator.create_buffer(42, false, 5)
Id3Taginator.create_picture_from_data('image/png', :COVER_FRONT, 'Description', 'Some picture data')
```
There is a create method for all Entities.

### Custom Frames

If a frame is currently not implemented, but is required, it can still be added or modified using Custom Frames. If the Frame is already
present in the ID3v2 Tag, then it will be available as a Custom Frame. Custom Frames can be added and modified as all other Frames
```ruby
# CSTM is the frame id of the frame we want to fetch
my_custom_frame = v2_tag.custom_frame('CSTM')
frame_content = my_custom_frame.content
# modify the content
v2_tag.add_custom_frame('CSTM', frame_content)

v2_tag.add_custom_frame('ABCD', 'my new frame content')
```
Here, the old content is replaced by the new content, and a new custom Frame is added.
If multiple custom frames with the same Frame ID should exist, an optional `selector_lambda` can be passed as an argument. 

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. 

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cfe86/id3taginator. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/cfe86/id3taginator/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Id3taginator project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/cfe86/id3taginator/blob/master/CODE_OF_CONDUCT.md).
