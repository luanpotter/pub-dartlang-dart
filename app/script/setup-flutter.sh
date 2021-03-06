#!/usr/bin/env bash

set -e

if [ "$GAE_SERVICE" != "analyzer" ];
then
  echo "Flutter setup aborted: GAE_SERVICE must be \"analyzer\"."
  # This shouldn't happen, GAE_SERVICE must be set.
  exit 1
fi

if [[ -z "$FLUTTER_SDK" ]];
then
  echo "Flutter setup aborted: FLUTTER_SDK must point to a target directory."
  exit 0
fi

if [ -d "$FLUTTER_SDK" ];
then
  echo "Flutter setup aborted: $FLUTTER_SDK already exists, assuming proper setup."
  # This shouldn't happen in docker, making sure this fails during an image build.
  exit 1
fi

git clone -b 0.0.17 --single-branch https://github.com/flutter/flutter.git $FLUTTER_SDK

# Keep in-sync with app/lib/analyzer/versions.dart
cd $FLUTTER_SDK

# Downloads the Dart SDK and disables analytics tracking – which we always want.
# This will add 400 MB.
$FLUTTER_SDK/bin/flutter config --no-analytics
