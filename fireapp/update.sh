#!/bin/bash

fvm exec flutter pub get
if [ ! -f ./lib/environment_config.dart ]
then
  dart run environment_config:generate
fi
fvm exec flutter gen-l10n
dart run build_runner build