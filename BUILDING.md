# How to build from source

## Project structure

This project has been started as fork of [Termux](https://github.com/termux)
application. There many common things, however as vShell needs only terminal
user interface, many things were either removed or modified to be suitable
for the new project.

- Top directory: Android application project root.
- `./app`: application source code (Java).
- `./images`: some graphical resources included in README.md and app logo.
- `./native-packages`: a build environment for compiling JNI library
  ([QEMU](https://qemu.org) + terminal initialization code).
- `./native-packages/jniLibs`: a prebuilt [QEMU](https://qemu.org) JNI
  libraries for each supported architecture. This directory is symlinked
  in app module.
- `./user-guide` a user guide Markdown sources.

## Requirements

It is expected that build will be performed on Linux host with Debian or
Ubuntu distribution. Other operating systems are untested.

- Installed packages:
  ```
  build-essential docker.io pandoc
  ```
- Java, at least version 8 (`openjdk-8-jdk`).
- Android SDK, path to installation should be exported in environment
  variable `ANDROID_HOME`.

## Compiling the JNI library

This step is optional as prebuilt JNI library is already available.

1. Build Docker image.
   ```
   cd ./native-packages/scripts
   docker build -t xeffyr/native-packages-buildenv .
   ```
2. Launch build environment:
   ```
   ./run-docker.sh
   ```
3. Compile `qemu` for all architectures.
   ```
   ./build-package.sh -a all qemu-system
   ```

## Compiling APK

1. Optionally: rebuild user guide page.
   ```
   cd ./user-guide
   make
   cd ..
   ```
2. Build debug version of APK.
   ```
   ./gradlew assembleDebug
   ```
   Per-architecture and universal APKs should be available in
   `./app/build/outputs/apk/debug`.
