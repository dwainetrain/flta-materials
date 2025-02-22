import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../../data/memory_repository.dart';
import '../../data/models/recipe.dart';

class MyRecipesList extends StatefulWidget {
  const MyRecipesList({Key? key}) : super(key: key);

  @override
  State createState() => _MyRecipesListState();
}

class _MyRecipesListState extends State<MyRecipesList> {
  List<Recipe> recipes = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: _buildRecipeList(context),
    );
  }

  Widget _buildRecipeList(BuildContext context) {
    return Consumer<MemoryRepository>(
      builder: (context, repository, child) {
        recipes = repository.findAllRecipes();
        return ListView.builder(
          itemCount: recipes.length,
          itemBuilder: (BuildContext context, int index) {
            final recipe = recipes[index];
            return SizedBox(
              height: 100,
              child: Slidable(
                startActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  extentRatio: 0.25,
                  children: [
                    SlidableAction(
                      label: 'Delete',
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.black,
                      icon: Icons.delete,
                      // TODO: Update first onPressed
                      onPressed: (context) {
                        deleteRecipe(repository, recipe);
                      },
                    ),
                  ],
                ),
                endActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  extentRatio: 0.25,
                  children: [
                    SlidableAction(
                      label: 'Delete',
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.black,
                      icon: Icons.delete,
                      // TODO: Update second onPressed
                      onPressed: (context) {
                        deleteRecipe(repository, recipe);
                      },
                    ),
                  ],
                ),
                child: Card(
                  elevation: 1.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Colors.white,
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        // TODO: Replace with image from recipe
                        // MockService
                        leading: Image.asset(
                          'assets/images/pizza_w700.png',
                          height: 200,
                          width: 200,
                        ),
                        // API Service
                        // leading: CachedNetworkImage(
                        //   imageUrl: recipe.image ?? '',
                        //   height: 120,
                        //   width: 60,
                        //   fit: BoxFit.cover,
                        // ),
                        // TODO: Replace title hardcoding
                        title: Text(recipe.label ?? ''),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void deleteRecipe(MemoryRepository repository, Recipe recipe) async {
    repository.deleteRecipe(recipe);
    // Can just redraw view by calling it...
    setState(() {});
  }
}
