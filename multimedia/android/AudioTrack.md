# AudioTrack

官方参考资料:[Android SDK - AudioTrack](https://developer.android.com/reference/android/media/AudioTrack)

现在AndroidStudio的创建官方建议使用Build, 写法参考官方资料: [Android SDK - AudioTrack.Builder](https://developer.android.com/reference/android/media/AudioTrack.Builder)

参考:
```
class MainActivity : AppCompatActivity() {
    private var button1: Button ?= null
    var isRunning = true
    var isAudioRunning = true
    var mediaCodecAudio: MediaCodec ?= null
    var mediaExtractor: MediaExtractor ?= null
    var audioTrack : AudioTrack ?= null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        button1 = findViewById(R.id.button1)
        button1?.setOnClickListener {
            object: Thread() {
                @RequiresApi(Build.VERSION_CODES.M)
                override fun run() {
                    play();
                }
            }.start()
        }
    }

    @RequiresApi(Build.VERSION_CODES.M)
    private fun play() {
        var minBufferSize = AudioTrack.getMinBufferSize(
                44100,
                AudioFormat.CHANNEL_OUT_STEREO,
                AudioFormat.ENCODING_PCM_16BIT
        )

        mediaExtractor = MediaExtractor()
        var fileName = "/storage/emulated/0/Download/test.wav"
        var fileInputStream = FileInputStream(fileName)
        mediaExtractor?.setDataSource(fileInputStream.fd)
        for(i in 0 until mediaExtractor?.trackCount!!) {
            var format = mediaExtractor?.getTrackFormat(i)
            var mime = format?.getString(MediaFormat.KEY_MIME)
            try {
                if(mime!!.startsWith("audio/")) {
                    mediaExtractor?.selectTrack(i)

                    audioTrack = AudioTrack.Builder().apply {
                        setAudioAttributes(AudioAttributes.Builder().apply {
                            setUsage(AudioAttributes.USAGE_MEDIA)
                            setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                        }.build())
                        setAudioFormat(AudioFormat.Builder().apply {
                            setEncoding(AudioFormat.ENCODING_PCM_16BIT)
                            setSampleRate(44100)
                            setChannelMask(AudioFormat.CHANNEL_OUT_STEREO)
                        }.build())
                        setBufferSizeInBytes(minBufferSize)
                        build()
                    }.build()

                    audioTrack?.play()

                    mediaCodecAudio = MediaCodec.createDecoderByType(mime)
                    mediaCodecAudio?.configure(format, null, null, 0)
                    mediaCodecAudio?.start()

                    AudioInputThread("Audio Input Thread").start()
                    AudioOutputThread("Audio Output Thread").start()
                    break;
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }
    inner class AudioInputThread(name: String) : Thread(name) {
        var startTime = 0L
        var startSample = 0L
        @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
        override fun run() {
            while(isRunning && isAudioRunning) {
                var index = mediaCodecAudio?.dequeueInputBuffer(1000L)
                if(index!! >= 0) {
                    var input = mediaCodecAudio?.getInputBuffer(index!!)
                    input!!.clear()
                    var size = mediaExtractor?.readSampleData(input!!, 0)
                    var flag = 0
                    if(size!! <= 0){
                        flag = MediaCodec.BUFFER_FLAG_END_OF_STREAM
                        isAudioRunning = false
                    }
                    if(startTime == 0L && mediaExtractor?.sampleTime!! > 0) {
                        startTime = System.currentTimeMillis()
                        startSample = mediaExtractor?.sampleTime!! / 1000 - startTime
                    } else if(startTime != 0L) {
                        var inner1 = System.currentTimeMillis() - startTime;
                        var inner2 = mediaExtractor?.sampleTime!! / 1000 - startTime
                        var dis = inner2 - inner1
                        if(dis >= 0) {
                            try {
                                sleep(dis)
                            } catch (e: Exception) {
                                e.printStackTrace()
                            }
                        }
                    }
                    try {
                        mediaCodecAudio?.queueInputBuffer(index, 0, size!!, System.currentTimeMillis(), flag)
                        mediaExtractor?.advance()
                    } catch (e: Exception) {}
                }
            }
        }
    }
    inner class AudioOutputThread(name: String) : Thread(name) {
        var lastTime = System.currentTimeMillis()
        var lastCount = 0
        var count = 0
        @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
        override fun run() {
            super.run()
            var info = MediaCodec.BufferInfo()
            while(isRunning) {
                try {
                    var index = mediaCodecAudio?.dequeueOutputBuffer(info, 1000L)
                    if(index!! >= 0) {
                        var outputBuffer: ByteBuffer? = null
                        outputBuffer = mediaCodecAudio?.getOutputBuffer(index)
                        audioTrack?.write(outputBuffer!!, info.size, AudioTrack.WRITE_BLOCKING)
                        mediaCodecAudio?.releaseOutputBuffer(index, false)
                    } else {
                        try {
                            sleep(1)
                        } catch (e: Exception) {}
                    }
                } catch (e: Exception) {

                }
            }
        }
    }
}
```