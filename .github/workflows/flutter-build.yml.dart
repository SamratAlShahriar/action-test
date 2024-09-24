name: Flutter Build

on:
push:
branches:
- main  # or any other branch you want to build on push
pull_request:
branches:
- main  # or any other branch you want to build on PR

jobs:
build:
name: Build Flutter project
runs-on: ubuntu-latest

strategy:
matrix:
platform: [android, ios]

steps:
# Checkout the repository
- name: Checkout repository
uses: actions/checkout@v3

# Set up Flutter SDK
- name: Set up Flutter
uses: subosito/flutter-action@v2
with:
flutter-version: 'stable'

# Run Flutter pub get to fetch dependencies
- name: Install dependencies
run: flutter pub get

# Android build step
- name: Build Android APK
if: matrix.platform == 'android'
run: flutter build apk --release

# iOS build step
- name: Build iOS IPA
if: matrix.platform == 'ios'
run: flutter build ios --release --no-codesign

# (Optional) Save APK or IPA as build artifacts
- name: Upload Android APK
if: matrix.platform == 'android'
uses: actions/upload-artifact@v3
with:
name: android-apk
path: build/app/outputs/flutter-apk/app-release.apk

- name: Upload iOS IPA
if: matrix.platform == 'ios'
uses: actions/upload-artifact@v3
with:
name: ios-ipa
path: build/ios/ipa/*.ipa
