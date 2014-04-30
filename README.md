iOSRTCDemo
==========

The origin WebRTC iOS example project for Xcode GUI. Easy to debug or install to you device.

Librarys can be download from here: https://dl.dropboxusercontent.com/u/5900843/iOSRTCLibs.7z

Extract the file to `libs` directory, build and run.


Build webrtc for iOS
==========

Download depot_tools:
`git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git`

Add depot_tools to path
`export PATH=/a_bunch_of_stuff:/working_directory/depot_tools:$PATH`

Then checkout WebRTC source code and run build script.
 `cd webrtc_src`
 `./makelib-iosall.sh`
 
The output libs will be in `trunk/outlibs`.
