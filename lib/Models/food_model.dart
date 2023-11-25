class Food {
  String id;
  String name;
  double price;
  String imageURL;
  String title;
  String description;

  Food({
    required this.id,
    required this.name,
    required this.price,
    required this.imageURL,
    required this.title,
    required this.description,
  });

  // Add a factory constructor to convert a Map to a Food object
  factory Food.fromMap(Map<String, dynamic> map) {
    return Food(
      id: map['id'],
      name: map['name'],
      price: map['price'].toDouble(),
      imageURL: map['imageURL'],
      title: map['title'],
      description: map['description'],
    );
  }
}
