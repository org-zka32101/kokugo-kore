#!/bin/bash
#
# Setup Android Emulator for Flutter testing
# Usage: ./setup-android-emulator.sh [--api-level <level>] [--arch <arch>] [--name <name>]
#

set -e

# Default values
API_LEVEL=${API_LEVEL:-29}
ARCH=${ARCH:-x86}
EMULATOR_NAME=${EMULATOR_NAME:-flutter_emulator}
SYSTEM_IMAGE="system-images;android;${API_LEVEL};${ARCH}"
AVD_DIR="${HOME}/.android/avd"

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --api-level)
      API_LEVEL="$2"
      SYSTEM_IMAGE="system-images;android;${API_LEVEL};${ARCH}"
      shift 2
      ;;
    --arch)
      ARCH="$2"
      SYSTEM_IMAGE="system-images;android;${API_LEVEL};${ARCH}"
      shift 2
      ;;
    --name)
      EMULATOR_NAME="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

echo "Setting up Android Emulator..."
echo "API Level: $API_LEVEL"
echo "Architecture: $ARCH"
echo "AVD Name: $EMULATOR_NAME"

# Accept Android SDK licenses (required in CI)
mkdir -p ~/.android
echo "y" | ${ANDROID_SDK_ROOT}/tools/bin/sdkmanager --licenses 2>&1 | head -20 || true

# Download system image if not present
echo "Installing system image..."
${ANDROID_SDK_ROOT}/tools/bin/sdkmanager --install "$SYSTEM_IMAGE" 2>&1 | grep -E "^(Downloading|Installed|Unzipping)" || true

# Create AVD if not exists
if [ ! -d "${AVD_DIR}/${EMULATOR_NAME}.avd" ]; then
  echo "Creating Android Virtual Device..."
  echo "no" | ${ANDROID_SDK_ROOT}/tools/bin/avdmanager create avd \
    -n "$EMULATOR_NAME" \
    -k "$SYSTEM_IMAGE" \
    -f 2>&1 | grep -v "^$" || true
fi

# Configure AVD for faster boot in CI
AVD_CONFIG="${AVD_DIR}/${EMULATOR_NAME}.avd/config.ini"
if [ -f "$AVD_CONFIG" ]; then
  echo "Configuring AVD for faster boot..."
  # Disable animations and enable headless mode
  sed -i 's/^hw.keyboard=.*/hw.keyboard=yes/' "$AVD_CONFIG"
  sed -i 's/^showDeviceFrame=.*/showDeviceFrame=no/' "$AVD_CONFIG"
  echo "hw.lcd.density=420" >> "$AVD_CONFIG" 2>/dev/null || true
  echo "hw.ramMB=2048" >> "$AVD_CONFIG" 2>/dev/null || true
fi

# Start emulator
echo "Starting Android Emulator..."
${ANDROID_SDK_ROOT}/emulator/emulator -avd "$EMULATOR_NAME" \
  -no-snapshot-load \
  -no-window \
  -no-audio \
  -no-boot-anim \
  -gpu off \
  -accel auto \
  -memory 2048 \
  -cores 2 \
  -verbose &

EMULATOR_PID=$!

# Wait for emulator to boot
echo "Waiting for emulator to boot (max 180 seconds)..."
timeout=180
elapsed=0
while [ $elapsed -lt $timeout ]; do
  if adb devices | grep -q "$EMULATOR_NAME\|emulator"; then
    echo "Emulator device detected"
    break
  fi
  sleep 5
  elapsed=$((elapsed + 5))
done

if [ $elapsed -ge $timeout ]; then
  echo "Warning: Emulator device not detected within timeout"
fi

# Wait for boot to complete
echo "Waiting for system boot completion..."
timeout=300
elapsed=0
while [ $elapsed -lt $timeout ]; do
  if adb shell getprop sys.boot_completed 2>/dev/null | grep -q "1"; then
    echo "System boot completed"
    break
  fi
  sleep 5
  elapsed=$((elapsed + 5))
done

if [ $elapsed -ge $timeout ]; then
  echo "Warning: System boot not completed within timeout"
fi

# Disable keyguard and notifications
echo "Configuring system..."
adb shell input keyevent 82 2>/dev/null || true
adb shell settings put global window_animation_scale 0 2>/dev/null || true
adb shell settings put global transition_animation_scale 0 2>/dev/null || true

echo "Android Emulator setup complete"
adb devices
