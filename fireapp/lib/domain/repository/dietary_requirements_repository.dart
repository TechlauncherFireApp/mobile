
import 'package:fireapp/domain/models/dietary_requirements.dart';
import 'package:injectable/injectable.dart';

@injectable
class DietaryRequirementsRepository {

  final _options = [
    const DietaryRestriction(key: "peanut", displayName: "Peanuts"),
    const DietaryRestriction(key: "fish", displayName: "Fish"),
    const DietaryRestriction(key: "vegetarian", displayName: "Vegetarian"),
    const DietaryRestriction(key: "vegan", displayName: "Vegan"),
  ];

  Future<List<DietaryRestriction>> getOptions() async {
    return _options;
  }

  Future<DietaryRequirements> getDietaryRequirements() async {
    return DietaryRequirements(
      restrictions: _options.sublist(2),
      customRestrictions: null
    );
  }

  Future<void> updateDietaryRequirements(DietaryRequirements requirements) async {}

}