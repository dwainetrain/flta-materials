import 'dart:async';

import '../models/models.dart';
import '../repository.dart';
import 'database_helper.dart';

class SqliteRepository extends Repository {
  final dbHelper = DatabaseHelper.instance;

  // TODO: Add methods to use dbHelper here
  @override
  Future<List<Recipe>> findAllRecipes() {
    return dbHelper.findAllRecipes();
  }

  @override
  Stream<List<Recipe>> watchAllRecipes() {
    return dbHelper.watchAllRecipes();
  }

  @override
  Stream<List<Ingredient>> watchAllIngredients() {
    return dbHelper.watchAllIngredients();
  }

  @override
  Future<Recipe> findRecipeById(int id) {
    return dbHelper.findRecipeById(id);
  }

  @override
  Future<List<Ingredient>> findAllIngredients() {
    return dbHelper.findAllIngredients();
  }

  @override
  Future<List<Ingredient>> findRecipeIngredients(int recipeId) {
    return dbHelper.findRecipeIngredients(recipeId);
  }

  @override
  Future<int> insertRecipe(Recipe recipe) {
    return Future(() async {
      final id = await dbHelper.insertRecipe(recipe);
      recipe.id = id;
      if (recipe.ingredients != null) {
        // TODO: Dwaine, I rewrote this line to get around a warning
        for (final ingredient in recipe.ingredients!) {
          ingredient.recipeId = id;
        }
        insertIngredients(recipe.ingredients!);
      }
      return id;
    });
  }

  @override
  Future<List<int>> insertIngredients(List<Ingredient> ingredients) {
    return Future(() async {
      // TODO: Ask Jim, is this another scenario
      //  where we should suppress the error?
      // setting this to isNotEmpty produces an error
      if (ingredients.isNotEmpty) {
        final ingredientIds = <int>[];
        await Future.forEach(ingredients, (Ingredient ingredient) async {
          final futureId = await dbHelper.insertIngredient(ingredient);
          ingredient.id = futureId;
          ingredientIds.add(futureId);
        });
        return Future.value(ingredientIds);
      } else {
        return Future.value(<int>[]);
      }
    });
  }

  @override
  Future<void> deleteRecipe(Recipe recipe) {
    dbHelper.deleteRecipe(recipe);
    if (recipe.id != null) {
      deleteRecipeIngredients(recipe.id!);
    }
    return Future.value();
  }

  @override
  Future<void> deleteIngredient(Ingredient ingredient) {
    dbHelper.deleteIngredient(ingredient);
    return Future.value();
  }

  @override
  Future<void> deleteIngredients(List<Ingredient> ingredients) {
    dbHelper.deleteIngredients(ingredients);
    return Future.value();
  }

  @override
  Future<void> deleteRecipeIngredients(int recipeId) {
    dbHelper.deleteRecipeIngredients(recipeId);
    return Future.value();
  }

  @override
  Future init() async {
    await dbHelper.database;
    return Future.value();
  }

  @override
  void close() {
    dbHelper.close();
  }
}
