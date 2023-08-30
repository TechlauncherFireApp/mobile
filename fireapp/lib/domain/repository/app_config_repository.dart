
import 'package:fireapp/data/persistence/app_config_persistence.dart';
import 'package:fireapp/environment_config.dart';
import 'package:injectable/injectable.dart';

@injectable
class AppConfigRepository {

  final AppConfigPersistence _appConfigPersistence;

  AppConfigRepository(this._appConfigPersistence);

  String? getServerUrl() {
    String? provided = EnvironmentConfig.serviceUrl;
    if (provided == "") {
      provided = null;
    }
    return provided ?? _appConfigPersistence.localServerUrl;
  }

  void setServerUrl(String url) {
    _appConfigPersistence.localServerUrl = url;
  }

}