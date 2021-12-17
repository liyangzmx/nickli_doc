### 关键参数
|定义|参数|含义|
|:-|:-|:-|
|`KEY_PREVIEW_SIZE`|"preview-size"|预览尺寸(像素, 宽 x 高)
|`KEY_SUPPORTED_PREVIEW_SIZES`|"preview-size-values"|所支持的预览尺寸列表|
|`KEY_PREVIEW_FPS_RANGE`|"preview-fps-range"|预览的帧率范围, 最大最小值应从 `KEY_SUPPORTED_PREVIEW_FPS_RANGE` 中取|
|`KEY_SUPPORTED_PREVIEW_FPS_RANGE`|"preview-fps-range-values"|预览时的帧速率范围选择列表, 每个项目都包含一个(最小值, 最大值)的范围, 如果范围内的两个值的相同, 则表示固定帧率, 范围从小到打一次排列.|
|`KEY_PREVIEW_FORMAT`|"preview-format"|预览时的[像素格式](#像素格式), 默认是:`PIXEL_FORMAT_YUV420SP`|
|`KEY_SUPPORTED_PREVIEW_FORMATS`|"preview-format-values"|支持的预览像素格式列表|
|`KEY_PREVIEW_FRAME_RATE`|"preview-frame-rate"|预览时的目标帧率|
|`KEY_SUPPORTED_PREVIEW_FRAME_RATES`|"preview-frame-rate-values"|支持的目标帧率列表|
|`KEY_PICTURE_SIZE`|"picture-size"|拍照尺寸|
|`KEY_SUPPORTED_PICTURE_SIZES`|"picture-size-values"|相机支持的拍照尺寸|
|`KEY_PICTURE_FORMAT`|"picture-format"|拍照时的[像素格式](#像素格式)|
|`KEY_SUPPORTED_PICTURE_FORMATS`|"picture-format-values"|拍照支持的像素格式列表|
|`KEY_JPEG_THUMBNAIL_WIDTH`|"jpeg-thumbnail-width"|EXIF thumbnail, EXIF的一种缓存图片, 宽度|
|`KEY_JPEG_THUMBNAIL_HEIGHT`|"jpeg-thumbnail-height"|EXIF缓存图片高度|
|`KEY_SUPPORTED_JPEG_THUMBNAIL_SIZES`|"jpeg-thumbnail-size-values"|所支持的EXIF缓存尺寸列表, 可选: "512x384,320x240,0x0", 0x0表示不支持缓存|
|`KEY_JPEG_THUMBNAIL_QUALITY`|"jpeg-thumbnail-quality"|EXIF缓存图像的质量, 范围: 0~100, 100表示最好|
|`KEY_JPEG_QUALITY`|"jpeg-quality"|JPEG图像的质量|
|`KEY_ROTATION`|"rotation"|相机可能只在EXIF中设置了方向数据, 但是没有实际的旋转方向, 因此上层软件可能需要额外的旋转, 可选: "0" or "90" or "180" or "270"|
|`KEY_GPS_LATITUDE`|"gps-latitude"|GPS维度信息|
|`KEY_GPS_LONGITUDE`|"gps-longitude"|GPS经度信息|
|`KEY_GPS_ALTITUDE`|"gps-altitude"|GPS海拔高度信息|
|`KEY_GPS_TIMESTAMP`|"gps-timestamp"|GPS时间戳, 采用UTC时间|
|`KEY_GPS_PROCESSING_METHOD`|"gps-processing-method"|GPS的处理方式, 可选: "GPS" or "NETWORK", 区分GPS/AGPS|
|`KEY_WHITE_BALANCE`|"whitebalance"|[白平衡](#白平衡)设置|

### 像素格式
|定义|参数|
|:-|:-|
|`PIXEL_FORMAT_YUV422SP`|"yuv422sp"|
|`PIXEL_FORMAT_YUV420SP`|"yuv420sp"|
|`PIXEL_FORMAT_YUV422I`|"yuv422i-yuyv"|
|`PIXEL_FORMAT_YUV420P`|"yuv420p"|
|`PIXEL_FORMAT_RGB565`|"rgb565"|
|`PIXEL_FORMAT_RGBA8888`|"rgba8888"|
|`PIXEL_FORMAT_JPEG`|"jpeg"|
|`PIXEL_FORMAT_BAYER_RGGB`|"bayer-rggb"|
|`PIXEL_FORMAT_ANDROID_OPAQUE`|"android-opaque"|

### 白平衡
|定义|参数|含义|
|:-|:-|:-|
|`WHITE_BALANCE_AUTO`|"auto"|自动|
|`WHITE_BALANCE_INCANDESCENT`|"incandescent"|白炽灯|
|`WHITE_BALANCE_FLUORESCENT`|"fluorescent"|荧光灯|
|`WHITE_BALANCE_DAYLIGHT`|"daylight"|日光|
|`WHITE_BALANCE_CLOUDY_DAYLIGHT`|"cloudy-daylight"|阴雨天|
|`WHITE_BALANCE_TWILIGHT`|"twilight"|
|`WHITE_BALANCE_SHADE`|"shade"|

### 场景模式
|定义|参数|含义|
|:-|:-|:-|
|`SCENE_MODE_AUTO`|"auto"|自动场景|
|`SCENE_MODE_ACTION`|"action"|运动场景|
|`SCENE_MODE_PORTRAIT`|"portrait"|人像模式|
|`SCENE_MODE_LANDSCAPE`|"landscape"|远景拍摄|
|`SCENE_MODE_NIGHT`|"night"|夜景模式|
|`SCENE_MODE_NIGHT_PORTRAIT`|"night-portrait"|夜景人像模式|
|`SCENE_MODE_THEATRE`|"theatre"|剧院场景, 关闭闪光灯|
|`SCENE_MODE_BEACH`|"beach"|海滩场景|
|`SCENE_MODE_SNOW`|"snow"|雪景拍摄|
|`SCENE_MODE_SUNSET`|"sunset"|日落场景|
|`SCENE_MODE_STEADYPHOTO`|"steadyphoto"|固定物体场景, 避免抖动造成的模糊|
|`SCENE_MODE_FIREWORKS`|"fireworks"|烟火表演场景|
|`SCENE_MODE_SPORTS`|"sports"|类似 `SCENE_MODE_ACTION`|
|`SCENE_MODE_PARTY`|"party"|室内弱光环境|
|`SCENE_MODE_CANDLELIGHT`|"candlelight"|烛光场景|
|`SCENE_MODE_BARCODE`|"barcode"|条码场景|
|`SCENE_MODE_HDR`|"hdr"|高动态范围场景|

### 对焦模式
|定义|参数|
|:-|:-|
|`FOCUS_MODE_AUTO|`"auto"|自动对焦|
|`FOCUS_MODE_INFINITY`|"infinity"|无限远|
|`FOCUS_MODE_MACRO`|"macro"|微距|
|`FOCUS_MODE_FIXED`|"fixed"|定焦|
|`FOCUS_MODE_EDOF`|"edof"|Extended Depth of Field, 扩展景深对焦, 常见于诺基亚手机...|
|`FOCUS_MODE_CONTINUOUS_VIDEO`|"continuous-video"|视频连续对焦|
|`FOCUS_MODE_CONTINUOUS_PICTURE`|"continuous-picture"|连拍连续对焦|