import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
      builder: (contexto) => Container(
        width: MediaQuery.of(context).size.width,
        height: 500,
        color: Colors.white,
        child: ReciperForm(),
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
  final TextEditingController _recipeName = TextEditingController();
  final TextEditingController _recipeAuthor = TextEditingController();
  final TextEditingController _recipeImage = TextEditingController();
  final TextEditingController _recipeDescription = TextEditingController();

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
    final _formKey = GlobalKey<FormState>();

    final fields = [
      {
        'label': 'Recipe Name',
        'maxLines': 1,
        'controller': _recipeName,
        'validator': (String? value) {
          if (value == null || value.isEmpty) {
            return 'Please enter the recipe name';
          }
          return null;
        },
      },
      {
        'label': 'Author',
        'maxLines': 1,
        'controller': _recipeAuthor,
        'validator': (String? value) {
          if (value == null || value.isEmpty) {
            return 'Please enter the author';
          }
          return null;
        },
      },
      {
        'label': 'Image Url',
        'maxLines': 1,
        'controller': _recipeImage,
        'validator': (String? value) {
          if (value == null || value.isEmpty) {
            return 'Please enter the image URL';
          }
          return null;
        },
      },
      {
        'label': 'Recipe',
        'maxLines': 4,
        'controller': _recipeDescription,
        'validator': (String? value) {
          if (value == null || value.isEmpty) {
            return 'Please enter the recipe';
          }
          return null;
        },
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Add New Recipe",
              style: TextStyle(color: Colors.orange, fontSize: 24),
            ),
            const SizedBox(height: 16),
            ...fields.map(
              (field) => Column(
                children: [
                  _buildTextField(
                    label: field['label'] as String,
                    controller: field['controller'] as TextEditingController,
                    validator: field['validator'] as String? Function(String?),
                    maxLines: field['maxLines'] as int,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () => {
                  if (_formKey.currentState!.validate())
                    {Navigator.pop(context)},
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Save Recipe',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildTextField({
  required String label,
  required TextEditingController controller,
  required String? Function(String?) validator,
  int maxLines = 1,
}) {
  return TextFormField(
    controller: controller,
    validator: validator,
    maxLines: maxLines,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(fontFamily: 'Quicksand', color: Colors.orange),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.orange, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}
