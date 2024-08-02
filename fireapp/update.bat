fvm exec flutter pub get
fvm exec dart run environment_config:generate
fvm exec flutter gen-l10n
fvm exec dart run build_runner build
