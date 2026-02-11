#!/bin/bash

set -e

echo "Cloning Flutter..."
git clone https://github.com/flutter/flutter.git -b stable --depth 1

echo "Adding Flutter to PATH..."
export PATH="$PWD/flutter/bin:$PATH"

flutter doctor
flutter pub get

echo "Building Flutter Web..."
flutter build web --release --web-renderer canvaskit \
  --dart-define=SUPABASE_URL=$SUPABASE_URL \
  --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY
