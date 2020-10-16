# mplayer使用中遇到的问题

## Failed to open LIRC support.
```
$ mplayer 'https://b-117b36f5.kinesisvideo.us-west-2.amazonaws.com/dash/v1/getDASHManifest.mpd?SessionToken=CiAXz2PFiCpXAlTVQjjt1Npp-p94gGGd8mqRzmrwA6DV3hIQtMCm5IHOtLiP0O--MzMfGhoZ_TZyOg9dqS35eZphBpFTWItRxmmcC-3ZeSIgOWeYGaGx6ZnWmTOaUwrUWCes7De7lS5bEJQLTltbBrE~'
MPlayer 1.3.0 (Debian), built with gcc-9 (C) 2000-2016 MPlayer Team
do_connect: could not connect to socket
connect: No such file or directory
Failed to open LIRC support. You will not be able to use your remote control.

Playing https://b-117b36f5.kinesisvideo.us-west-2.amazonaws.com/dash/v1/getDASHManifest.mpd?SessionToken=CiAXz2PFiCpXAlTVQjjt1Npp-p94gGGd8mqRzmrwA6DV3hIQtMCm5IHOtLiP0O--MzMfGhoZ_TZyOg9dqS35eZphBpFTWItRxmmcC-3ZeSIgOWeYGaGx6ZnWmTOaUwrUWCes7De7lS5bEJQLTltbBrE~.
```

修改`~/.mplayer/config`:
```
# Write your default config options here!

# 新增如下行
lirc=no
```

## Cannot seek backward in linear streams!
```
$ mplayer 'https://b-117b36f5.kinesisvideo.us-west-2.amazonaws.com/dash/v1/getDASHManifest.mpd?SessionToken=CiAXz2PFiCpXAlTVQjjt1Npp-p94gGGd8mqRzmrwA6DV3hIQtMCm5IHOtLiP0O--MzMfGhoZ_TZyOg9dqS35eZphBpFTWItRxmmcC-3ZeSIgOWeYGaGx6ZnWmTOaUwrUWCes7De7lS5bEJQLTltbBrE~'
MPlayer 1.3.0 (Debian), built with gcc-9 (C) 2000-2016 MPlayer Team

Playing https://b-117b36f5.kinesisvideo.us-west-2.amazonaws.com/dash/v1/getDASHManifest.mpd?SessionToken=CiAXz2PFiCpXAlTVQjjt1Npp-p94gGGd8mqRzmrwA6DV3hIQtMCm5IHOtLiP0O--MzMfGhoZ_TZyOg9dqS35eZphBpFTWItRxmmcC-3ZeSIgOWeYGaGx6ZnWmTOaUwrUWCes7De7lS5bEJQLTltbBrE~.
libavformat version 58.29.100 (external)
Cannot seek backward in linear streams!
Cannot seek backward in linear streams!
Cannot seek backward in linear streams!
Cannot seek backward in linear streams!
Cannot seek backward in linear streams!
```