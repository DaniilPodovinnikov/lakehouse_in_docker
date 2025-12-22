#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

keytool \
  -genkeypair \
  -storetype jks \
  -keystore ${SCRIPT_DIR}/selfsigned.jks \
  -alias selfsigned \
  -storepass password \
  -keypass password \
  -keyalg RSA \
  -keysize 2048 \
  -validity 360 \
  -dname "CN=My SSL Certificate, OU=My Team, O=My Company, L=My City, ST=My State, C=SA"