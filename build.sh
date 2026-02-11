#!/bin/bash
set -e

echo "Downloading Flutter stable..."

curl -L https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.22.2-stable.tar.xz -o flutter.tar.xz
tar -xf flutter.tar.xz
export PATH="$PWD/flutter/bin:$PATH"

flutter --version
flutter config --enable-web

flutter pub get

echo "Building Flutter Web..."
flutter build web --release \
  --dart-define=SUPABASE_URL=$SUPABASE_URL \
  --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY
