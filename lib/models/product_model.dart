class ProductModel {
  final int? id;
  final String? title;
  final double? price;
  final String? image;

  ProductModel({this.id, this.title, this.price, this.image});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Logic to extract the first image from Platzi's list
    String? imageUrl;
    if (json['images'] != null && (json['images'] as List).isNotEmpty) {
      imageUrl = (json['images'] as List)[0];
      
      // Quick fix: Sometimes Platzi returns messy URLs with brackets/quotes
      if (imageUrl != null && imageUrl.startsWith('["')) {
        imageUrl = imageUrl.replaceAll('["', '').replaceAll('"]', '').replaceAll('"', '');
      }
    }

    return ProductModel(
      id: json['id'],
      title: json['title'],
      // Safely convert price to double (sometimes APIs send integers)
      price: (json['price'] as num?)?.toDouble(),
      image: imageUrl,
    );
  }
}