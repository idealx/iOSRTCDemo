function fetch() {
    echo "-- fetching webrtc"
    gclient config http://webrtc.googlecode.com/svn/trunk/
    echo "target_os = ['ios', 'mac']" >> .gclient
    gclient sync
    echo "-- webrtc has been sucessfully fetched"
}
 
function wrbase() {
    export GYP_DEFINES="build_with_libjinglth_chromium=0 libjingle_objc=1"
    export GYP_GENERATORS="ninja"
}

# ====== simulator
function wrsim() {
    wrbase
    export GYP_DEFINES="$GYP_DEFINES OS=ios target_arch=ia32"
    export GYP_GENERATOR_FLAGS="$GYP_GENERATOR_FLAGS output_dir=out_sim"
    export GYP_CROSSCOMPILE=1
}

function buildsim() {
    echo "-- building webrtc"
    pushd trunk
    gclient runhooks
    ninja -C out_sim/Debug iossim AppRTCDemo
    popd
    echo "-- webrtc arch=mac has been sucessfully built"
}
 
# ====== device: armv7
function wrios() {
    wrbase
    export GYP_DEFINES="$GYP_DEFINES OS=ios target_arch=armv7"
    export GYP_GENERATOR_FLAGS="$GYP_GENERATOR_FLAGS output_dir=out_ios"
    export GYP_CROSSCOMPILE=1
}
 
function buildios() {
    echo "-- building webrtc ios"
    pushd trunk
    wrios && gclient runhooks && ninja -C out_ios/Debug-iphoneos AppRTCDemo
    popd
    echo "-- webrtc has been sucessfully built"
}


function launch() {
    echo "-- launching on device"
    ideviceinstaller -i trunk/out_ios/Debug-iphoneos/AppRTCDemo.app
    echo "-- launch complete"
}
 
function fail() {
    echo "*** webrtc build failed"
    exit 1
}
 
fetch || fail

# simulator
wrsim || fail
buildsim || fail

# device
wrios || fail
buildios || fail

#launch || fail

# combian libs
mkdir -p trunk/out_libs

pushd trunk/out_sim/Debug
for f in *.a; do
    if [ -f "../../out_ios/Debug-iphoneos/$f" ]; then
        echo "-- Create fat static library $f"
        lipo -create "$f" "../../out_ios/Debug-iphoneos/$f" -output "../../out_libs/$f"
    else
        echo "$f was no build for iPhone"
        cp "$f" "../../out_libs/"
    fi
done
popd

pushd ../../out_ios/Debug-iphoneos
for f in *.a; do
    if [ -f "../../out_sim/Debug/$f" ]; then
        echo "-- Create fat static library $f"
        lipo -create "$f" "../../out_sim/Debug/$f" -output "../../out_libs/$f"
    else
        echo "$f was no build for simulator"
        cp "$f" "../../out_libs/"
    fi
done
popd

echo "-- Copy headers"
cp -r trunk/talk/app/webrtc/objc/public trunk/out_libs/
