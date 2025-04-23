import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:recipe_book/models/recipe_model.dart';
import 'package:http/http.dart' as http;

class RecipesProvider extends ChangeNotifier {
  bool isLoading = false;
  List<Recipe> recipes = [];
  List<Recipe> favoriteRecipe = [];

  Future<void> fetchRecipes() async {
    //puertos para acceder a la data clase 15 minuto 7
    // Android 10.0.2.2
    //IOS 127.0.0.1
    //WEB localhost
    isLoading = true;
    notifyListeners();
    // final url = Uri.parse('http://localhost:12346/recipe');Esta es para web
    final url = Uri.parse('http://10.0.2.2:12346/recipe');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        recipes = List<Recipe>.from(
          data['recipes'].map((recipe) => Recipe.fromJson(recipe)),
        );
        return data['recipes'];
      } else {
        print('Error ${response.statusCode}');
        recipes = [];
      }
    } catch (e) {
      print('Error in request');
      recipes = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleFavoritesStatus(Recipe recipe) async {
    final isFavorite = favoriteRecipe.contains(recipe);
    try {
      final url = Uri.parse('http://10.0.2.2:12346/favorites');
      final response =
          isFavorite
              ? await http.delete(url, body: json.encode({"id": recipe.id}))
              : await http.post(url, body: json.encode(recipe.toJson()));

      if (response.statusCode == 200) {
        if (isFavorite) {
          favoriteRecipe.remove(recipe);
        } else {
          favoriteRecipe.add(recipe);
        }
        notifyListeners();
      } else {
        print('Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to Updated favorite recipes');
      }
    } catch (e) {
      print('Error updating favotes status ${e} ');
    }
  }
}
