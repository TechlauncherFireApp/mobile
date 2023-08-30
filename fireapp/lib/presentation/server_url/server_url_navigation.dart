import 'package:freezed_annotation/freezed_annotation.dart';

part 'server_url_navigation.freezed.dart';

@freezed
class ServerUrlNavigation with _$ServerUrlNavigation {
  const factory ServerUrlNavigation.home() = Home;
}