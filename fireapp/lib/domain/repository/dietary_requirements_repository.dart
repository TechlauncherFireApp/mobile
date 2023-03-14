
import 'package:fireapp/domain/models/dietary_requirements.dart';
import 'package:injectable/injectable.dart';

@injectable
class DietaryRequirementsRepository {

  final _options = [
    const DietaryRestriction(key: "peanut", displayName: "Peanuts")
  ];

  Future<List<DietaryRestriction>> getOptions() async {
    return _options;
  }

  Future<DietaryRequirements> getDietaryRequirements() async {
    return DietaryRequirements(
      restrictions: _options,
      customRestrictions: null
    );
  }

  Future<void> updateDietaryRequirements(DietaryRequirements requirements) async {}

}