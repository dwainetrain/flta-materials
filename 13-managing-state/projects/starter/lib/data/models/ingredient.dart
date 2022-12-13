import 'package:equatable/equatable.dart';

// TODO: Should we be concerned about warnings like this?
class Ingredient extends Equatable {
  int? id;
  int? recipeId;
  final String name;
  final double weight;

  Ingredient({
    this.id,
    this.recipeId,
    required this.name,
    required this.weight,
  });

  @override
  List<Object?> get props => [
        recipeId,
        name,
        weight,
      ];
}
