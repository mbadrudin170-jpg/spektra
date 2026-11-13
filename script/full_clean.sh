#!/bin/bash
set -e

echo "🛑 Stopping Gradle daemons..."
(cd android && chmod +x gradlew && ./gradlew --stop 2>/dev/null) || true

echo "🧹 Running flutter clean..."
flutter clean

echo "🗑️ Removing local build artifacts..."
rm -rf build/ .dart_tool/ android/.gradle/ android/app/build/
rm -f .flutter-plugins .flutter-plugins-dependencies

echo "⚙️ Cleaning Gradle caches..."
rm -rf ~/.gradle/caches/

echo "🗑️ Removing old Gradle distributions (keeping 9.3.1)..."
rm -rf ~/.gradle/wrapper/dists/gradle-8.9-bin/

echo "🧹 Cleaning Android cache..."
rm -rf ~/.android/cache/

echo "🗑️ Cleaning Maven cache..."
rm -rf ~/.m2/repository/

echo "📦 Cleaning Dart/Flutter caches..."
rm -rf ~/.dartServer
rm -rf ~/.cache/flutter_tools*
rm -rf ~/.cache/dart*

echo "📦 Cleaning pub cache..."
rm -rf ~/.pub-cache

echo "🧹 Cleaning Cloud Shell editor cache..."
rm -rf ~/.codeoss

echo "🗑️ Cleaning Gemini history..."
rm -rf ~/.gemini

echo "⚡ Fetching fresh dependencies..."
flutter pub get

echo "🔨 Re-running build_runner..."
flutter pub run build_runner build --delete-conflicting-outputs

echo ""
echo "📊 Disk usage after cleanup:"
df -h
