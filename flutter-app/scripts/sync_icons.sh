#!/bin/bash
# Generate Web and iOS icons from Android ic_launcher (DietPal logo)
set -e
SRC="/Users/zhimin/IdeaProjects/CS3305/flutter-app/android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png"
WEB_DIR="/Users/zhimin/IdeaProjects/CS3305/flutter-app/web"
IOS_DIR="/Users/zhimin/IdeaProjects/CS3305/flutter-app/ios/Runner/Assets.xcassets/AppIcon.appiconset"

resize() {
  local w=$1 h=$2 out=$3
  sips -z "$h" "$w" "$SRC" --out "$out"
}

# Web: favicon + icons/
resize 48 48 "$WEB_DIR/favicon.png"
resize 192 192 "$WEB_DIR/icons/Icon-192.png"
resize 512 512 "$WEB_DIR/icons/Icon-512.png"
resize 192 192 "$WEB_DIR/icons/Icon-maskable-192.png"
resize 512 512 "$WEB_DIR/icons/Icon-maskable-512.png"

# iOS: all sizes required by Contents.json
resize 40 40 "$IOS_DIR/Icon-App-20x20@2x.png"
resize 60 60 "$IOS_DIR/Icon-App-20x20@3x.png"
resize 29 29 "$IOS_DIR/Icon-App-29x29@1x.png"
resize 58 58 "$IOS_DIR/Icon-App-29x29@2x.png"
resize 87 87 "$IOS_DIR/Icon-App-29x29@3x.png"
resize 80 80 "$IOS_DIR/Icon-App-40x40@2x.png"
resize 120 120 "$IOS_DIR/Icon-App-40x40@3x.png"
resize 120 120 "$IOS_DIR/Icon-App-60x60@2x.png"
resize 180 180 "$IOS_DIR/Icon-App-60x60@3x.png"
resize 20 20 "$IOS_DIR/Icon-App-20x20@1x.png"
resize 40 40 "$IOS_DIR/Icon-App-40x40@1x.png"
resize 76 76 "$IOS_DIR/Icon-App-76x76@1x.png"
resize 152 152 "$IOS_DIR/Icon-App-76x76@2x.png"
resize 168 168 "$IOS_DIR/Icon-App-83.5x83.5@2x.png"
resize 1024 1024 "$IOS_DIR/Icon-App-1024x1024@1x.png"

echo "Done: Web + iOS icons generated from Android ic_launcher."
