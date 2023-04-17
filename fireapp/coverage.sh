flutter test --coverage
flutter pub global run remove_from_coverage:remove_from_coverage -f coverage/lcov.info -r "\.g\.dart$" -r "\.freezed\.dart$" -r "\.config\.dart$" -r "di\.dart$" -r "test" -r "_navigation\.dart$" -r "domain/models"
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html