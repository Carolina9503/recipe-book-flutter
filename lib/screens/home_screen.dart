import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book/models/recipe_model.dart';
import 'package:recipe_book/providers/recipes_provider.dart';
import 'package:recipe_book/screens/recipe_detail.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final recipesProvider = Provider.of<RecipesProvider>(
      context,
      listen: false,
    );
    recipesProvider.fetchRecipes();

    return Scaffold(
      body: Consumer<RecipesProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (provider.recipes.isEmpty) {
            return Center(child: Text(AppLocalizations.of(context)!.noRecipes));
          } else {
            return ListView.builder(
              itemCount: provider.recipes.length,
              itemBuilder: (context, index) {
                return _RecipesCard(context, provider.recipes[index]);
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          _showBottom(context);
        },
      ),
    );
  }

  Future<void> _showBottom(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              top: 16,
              left: 16,
              right: 16,
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: ReciperForm(),
            ),
          );
        },
      ),
    );
  }

  Widget _RecipesCard(BuildContext context, dynamic recipe) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetail(recipesData: recipe),
          ),
        ),
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 125,
          child: Card(
            child: Row(
              children: [
                Container(
                  height: 125,
                  width: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      recipe.image_link,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 26),
                Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, //organizar vertical
                  crossAxisAlignment:
                      CrossAxisAlignment.start, //organizar horizontal
                  children: <Widget>[
                    Text(
                      recipe.name,
                      style: TextStyle(fontSize: 16, fontFamily: 'Quicksand'),
                    ),
                    SizedBox(height: 4),
                    Container(height: 2, width: 75, color: Colors.orange),
                    Text(
                      ('By ${recipe.author}'),
                      style: TextStyle(fontSize: 16, fontFamily: 'Quicksand'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ReciperForm extends StatefulWidget {
  const ReciperForm({super.key});

  @override
  State<ReciperForm> createState() => _ReciperFormState();
}

class _ReciperFormState extends State<ReciperForm> {
  final _formKey = GlobalKey<FormState>();
  final _recipeName = TextEditingController();
  final _recipeAuthor = TextEditingController();
  final _recipeImage = TextEditingController();
  final _recipeDescription = TextEditingController();

  @override
  void dispose() {
    _recipeName.dispose();
    _recipeAuthor.dispose();
    _recipeImage.dispose();
    _recipeDescription.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min, // ¡IMPORTANTE!
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Add New Recipe",
              style: TextStyle(color: Colors.orange, fontSize: 24),
            ),
            const SizedBox(height: 16),
            _buildTextField("Recipe Name", _recipeName),
            const SizedBox(height: 12),
            _buildTextField("Author", _recipeAuthor),
            const SizedBox(height: 12),
            _buildTextField("Image Url", _recipeImage),
            const SizedBox(height: 12),
            _buildTextField("Recipe", _recipeDescription, maxLines: 4),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newRecipe = Recipe(
                      id: DateTime.now()
                          .millisecondsSinceEpoch, // ID único temporal
                      name: _recipeName.text,
                      author: _recipeAuthor.text,
                      image_link: _recipeImage.text,
                      recipe: _recipeDescription.text
                          .split('\n'), // ✅ ahora es List<String>
                    );

                    Provider.of<RecipesProvider>(context, listen: false)
                        .addRecipe(newRecipe);

                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                child: const Text('Save Recipe'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        labelStyle: TextStyle(fontFamily: 'Quicksand', color: Colors.orange),
      ),
      validator: (value) =>
          (value == null || value.isEmpty) ? 'Please enter $label' : null,
    );
  }
}
