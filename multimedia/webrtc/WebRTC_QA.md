# WebRTC 设置 Q&A

## Q:如何设置分辨率和帧率?
WebRTC的图像分辨率取决于发送方的`VideoCapture`的实现, 在该接口类的`void startCapture(int width, int height, int framerate);`接口中, 可以设置分辨率与帧率.

## Q: 如何设置音视频的比特率?
WebRTC使用SDP交换媒体格式的支持情况, 同样SDP中也包含指定格式的扩展设置, bitrate就是扩展设置中的一项, 例如opus支持设置bitrate, 那么sdp:
```
a=rtpmap:111 opus/48000/2
a=fmtp:111 minptime=10;useinbandfec=1;maxaveragebitrate=xxxx
```
如上`fmtp`表示:**补充描述编码个是的参数**, 是**Format Parameters**的缩写, 而参数`maxaveragebitrate=xxxx`表示平均比特率, Google官方实现了`String setStartBitrate(String codec, boolean isVideoCodec, String sdpDescription, int bitrateKbps)`方法:
```
  @SuppressWarnings("StringSplitter")
  private static String setStartBitrate(
      String codec, boolean isVideoCodec, String sdpDescription, int bitrateKbps) {
    String[] lines = sdpDescription.split("\r\n");
    int rtpmapLineIndex = -1;
    boolean sdpFormatUpdated = false;
    String codecRtpMap = null;
    // Search for codec rtpmap in format
    // a=rtpmap:<payload type> <encoding name>/<clock rate> [/<encoding parameters>]
    String regex = "^a=rtpmap:(\\d+) " + codec + "(/\\d+)+[\r]?$";
    Pattern codecPattern = Pattern.compile(regex);
    for (int i = 0; i < lines.length; i++) {
      Matcher codecMatcher = codecPattern.matcher(lines[i]);
      if (codecMatcher.matches()) {
        codecRtpMap = codecMatcher.group(1);
        rtpmapLineIndex = i;
        break;
      }
    }
    if (codecRtpMap == null) {
      Log.w(TAG, "No rtpmap for " + codec + " codec");
      return sdpDescription;
    }
    Log.d(TAG, "Found " + codec + " rtpmap " + codecRtpMap + " at " + lines[rtpmapLineIndex]);

    // Check if a=fmtp string already exist in remote SDP for this codec and
    // update it with new bitrate parameter.
    regex = "^a=fmtp:" + codecRtpMap + " \\w+=\\d+.*[\r]?$";
    codecPattern = Pattern.compile(regex);
    for (int i = 0; i < lines.length; i++) {
      Matcher codecMatcher = codecPattern.matcher(lines[i]);
      if (codecMatcher.matches()) {
        Log.d(TAG, "Found " + codec + " " + lines[i]);
        if (isVideoCodec) {
          lines[i] += "; " + VIDEO_CODEC_PARAM_START_BITRATE + "=" + bitrateKbps;
        } else {
          lines[i] += "; " + AUDIO_CODEC_PARAM_BITRATE + "=" + (bitrateKbps * 1000);
        }
        Log.d(TAG, "Update remote SDP line: " + lines[i]);
        sdpFormatUpdated = true;
        break;
      }
    }

    StringBuilder newSdpDescription = new StringBuilder();
    for (int i = 0; i < lines.length; i++) {
      newSdpDescription.append(lines[i]).append("\r\n");
      // Append new a=fmtp line if no such line exist for a codec.
      if (!sdpFormatUpdated && i == rtpmapLineIndex) {
        String bitrateSet;
        if (isVideoCodec) {
          bitrateSet =
              "a=fmtp:" + codecRtpMap + " " + VIDEO_CODEC_PARAM_START_BITRATE + "=" + bitrateKbps;
        } else {
          bitrateSet = "a=fmtp:" + codecRtpMap + " " + AUDIO_CODEC_PARAM_BITRATE + "="
              + (bitrateKbps * 1000);
        }
        Log.d(TAG, "Add remote SDP line: " + bitrateSet);
        newSdpDescription.append(bitrateSet).append("\r\n");
      }
    }
    return newSdpDescription.toString();
  }
```

## Q: 如何设置首选编码格式?
WebRTC使用SDP交换媒体格式的支持情况, 同样SDP中也包含首选编码格式的指示, 这需要根据`a=rtpmap:`修改`m=video`对应的行, 官方实现了`String preferCodec(String sdpDescription, String codec, boolean isAudio)`方法, 实现如下:
```
  /** Returns the line number containing "m=audio|video", or -1 if no such line exists. */
  private static int findMediaDescriptionLine(boolean isAudio, String[] sdpLines) {
    final String mediaDescription = isAudio ? "m=audio " : "m=video ";
    for (int i = 0; i < sdpLines.length; ++i) {
      if (sdpLines[i].startsWith(mediaDescription)) {
        return i;
      }
    }
    return -1;
  }

  private static String joinString(
      Iterable<? extends CharSequence> s, String delimiter, boolean delimiterAtEnd) {
    Iterator<? extends CharSequence> iter = s.iterator();
    if (!iter.hasNext()) {
      return "";
    }
    StringBuilder buffer = new StringBuilder(iter.next());
    while (iter.hasNext()) {
      buffer.append(delimiter).append(iter.next());
    }
    if (delimiterAtEnd) {
      buffer.append(delimiter);
    }
    return buffer.toString();
  }

  private static @Nullable String movePayloadTypesToFront(
      List<String> preferredPayloadTypes, String mLine) {
    // The format of the media description line should be: m=<media> <port> <proto> <fmt> ...
    final List<String> origLineParts = Arrays.asList(mLine.split(" "));
    if (origLineParts.size() <= 3) {
      Log.e(TAG, "Wrong SDP media description format: " + mLine);
      return null;
    }
    final List<String> header = origLineParts.subList(0, 3);
    final List<String> unpreferredPayloadTypes =
        new ArrayList<>(origLineParts.subList(3, origLineParts.size()));
    unpreferredPayloadTypes.removeAll(preferredPayloadTypes);
    // Reconstruct the line with |preferredPayloadTypes| moved to the beginning of the payload
    // types.
    final List<String> newLineParts = new ArrayList<>();
    newLineParts.addAll(header);
    newLineParts.addAll(preferredPayloadTypes);
    newLineParts.addAll(unpreferredPayloadTypes);
    return joinString(newLineParts, " ", false /* delimiterAtEnd */);
  }

  private static String preferCodec(String sdpDescription, String codec, boolean isAudio) {
    final String[] lines = sdpDescription.split("\r\n");
    final int mLineIndex = findMediaDescriptionLine(isAudio, lines);
    if (mLineIndex == -1) {
      Log.w(TAG, "No mediaDescription line, so can't prefer " + codec);
      return sdpDescription;
    }
    // A list with all the payload types with name |codec|. The payload types are integers in the
    // range 96-127, but they are stored as strings here.
    final List<String> codecPayloadTypes = new ArrayList<>();
    // a=rtpmap:<payload type> <encoding name>/<clock rate> [/<encoding parameters>]
    final Pattern codecPattern = Pattern.compile("^a=rtpmap:(\\d+) " + codec + "(/\\d+)+[\r]?$");
    for (String line : lines) {
      Matcher codecMatcher = codecPattern.matcher(line);
      if (codecMatcher.matches()) {
        codecPayloadTypes.add(codecMatcher.group(1));
      }
    }
    if (codecPayloadTypes.isEmpty()) {
      Log.w(TAG, "No payload types with name " + codec);
      return sdpDescription;
    }

    final String newMLine = movePayloadTypesToFront(codecPayloadTypes, lines[mLineIndex]);
    if (newMLine == null) {
      return sdpDescription;
    }
    Log.d(TAG, "Change media description from: " + lines[mLineIndex] + " to " + newMLine);
    lines[mLineIndex] = newMLine;
    return joinString(Arrays.asList(lines), "\r\n", true /* delimiterAtEnd */);
  }
```

## Q: 启用硬件加速与不启用硬件加速的区别?
区别在与`VideoEncoderFactory`和`VideoDecoderFactory`的实现将不同:
* **未启用**硬件加速
  * `DefaultVideoEncoderFactory`
  * `DefaultVideoDecoderFactory`
* **启用**硬件加速
  * `SoftwareVideoEncoderFactory`
  * `SoftwareVideoDecoderFactory`

而对于`PeerConnectionFactory.Builder`的:
* `Builder setVideoEncoderFactory(VideoEncoderFactory videoEncoderFactory)`
* `Builder setVideoDecoderFactory(VideoDecoderFactory videoDecoderFactory)`

自然也是不同的参数了.

--- ---
## 待续...