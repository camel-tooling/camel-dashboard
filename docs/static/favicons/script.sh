#!/bin/bash

# Input file
SOURCE="transparent_logo_new.png"
OUT_DIR="icons"

# Create directories
mkdir -p $OUT_DIR/android
mkdir -p $OUT_DIR/web

echo "Generating icons..."

# 1. Web Favicons & Apple Touch
magick $SOURCE -resize 16x16 -sharpen 0x1 $OUT_DIR/web/favicon-16x16.png
magick $SOURCE -resize 32x32 -sharpen 0x1 $OUT_DIR/web/favicon-32x32.png
magick $SOURCE -resize 180x180 $OUT_DIR/web/apple-touch-icon-180x180.png
magick $SOURCE -define icon:auto-resize=64,48,32,16 $OUT_DIR/web/favicon.ico

# 2. Android Standard Icons
declare -A android_sizes=( ["36"]="36x36" ["48"]="48x48" ["72"]="72x72" ["96"]="96x96" ["144"]="144x144" ["192"]="192x192" )

for size in "${!android_sizes[@]}"; do
    magick $SOURCE -resize ${android_sizes[$size]} $OUT_DIR/android/android-$size"x"$size.png
done

# 3. Adaptive Icon Foreground (The 108dp standard)
# We resize the logo to roughly 66% of the canvas to stay in the "Safe Zone"
magick $SOURCE -resize 72x72 -gravity center -background none -extent 108x108 $OUT_DIR/android/ic_launcher_foreground.png

# 4. Adaptive Icon Background (Purple color from your logo)
magick -size 108x108 xc:"#433285" $OUT_DIR/android/ic_launcher_background.png

echo "Done! Check the '$OUT_DIR' folder."