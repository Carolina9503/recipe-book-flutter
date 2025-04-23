class Recipe {
  int id;
  String name;
  String author;
  String image_link;
  List<String> recipe;

  Recipe({
    required this.id,
    required this.name,
    required this.author,
    required this.image_link,
    required this.recipe,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
    id: json["id"],
    name: json["name"],
    author: json["author"],
    image_link: json["image_link"],
    recipe: List<String>.from(json["recipe"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "author": author,
    "image_link": image_link,
    "recipe": recipe,
    // "recipe": List<dynamic>.from(recipe.map((x) => x)),
  };

  //Que nos permite que cada vez que nosotros 
  //imprimimos nuestras variables verlas a travez de las consolas
  @override
  String toString() {
    // TODO: implement ==
    return 'Recipe{id : $id, name: $name, author: $author, image_link: $image_link, recipe: $recipe}';
  }
}
