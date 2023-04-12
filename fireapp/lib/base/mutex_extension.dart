
import 'package:mutex/mutex.dart';

extension MutexExtension on Mutex {

  void withLock(Function() fun) async {
    await acquire();
    try {
      await fun();
      release();
    } catch(_) {
      release();
      rethrow;
    }
  }

}