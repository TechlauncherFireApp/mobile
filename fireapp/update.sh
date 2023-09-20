#!/bin/bash

flutter pub get
if [ ! -f ./lib/environment_config.dart ]
then
  dart run environment_config:generate
fi
flutter gen-l10n
dart run build_runner build