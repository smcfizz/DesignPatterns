/*
* The Facade pattern provides a simplified interface to a library, framework,
* or subsystem to client code.
*
* Sometimes an Additional Facade class can be created to prevent polluting a
* single facade with unrelated features that might make it yet another complex
* structure. Additional facades can be used by both clients and other facades.
*
* The example used below is of a Facade that simplifies interaction with a
* complex video conversion framework.
*/

import 'dart:io';

void main() async {
  VideoConverter converter = VideoConverter();
  File mp4 = await converter.convert('filename.ogg', 'mp4');
}

/*
* Say the following classes are some of the classes that make up a complex
* 3rd-party video conversion framework. We do not control this code, so we
* cannot simplify it. The exact implementation details have been left out.
*/

class VideoFile {
  VideoFile(this.name);
  String name;
}
abstract class Codec {}
class OggCompressionCodec extends Codec {}
class MPEG4CompressionCodec extends Codec {}
class CodecFactory {
  static Codec extract(VideoFile file) {
    return MPEG4CompressionCodec();
  }
}
class BitrateReader {
  static List<int> read(String filename, Codec codec) {
    return [];
  }
  static List<int> convert(List<int> buffer, Codec codec) {
    return [];
  }
}
class AudioMixer {
  List<int> fix(List<int> buffer) {
    return [];
  }
}

// We create a Facade class to hide the framework's complexity behind a simple
// interface. It's a trade-off between functionality and simplicity.

class VideoConverter {
  Future<File> convert(String filename, String format) async {
    VideoFile file = VideoFile(filename);
    Codec sourceCodec = CodecFactory.extract(file);
    Codec destinationCodec;
    if (format == "mp4") {
      destinationCodec = MPEG4CompressionCodec();
    } else {
      destinationCodec = OggCompressionCodec();
    }
    var buffer = BitrateReader.read(filename, sourceCodec);
    var result = BitrateReader.convert(buffer, destinationCodec);
    result = AudioMixer().fix(buffer);
    File f = File('/some/path/here');
    return await f.writeAsBytes(result);
  }
}
