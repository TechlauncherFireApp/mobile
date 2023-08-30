#!/bin/bash

flutter pub get
dart run environment_config:generate
flutter gen-l10n
dart run build_runner build