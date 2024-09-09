
class DeliveryChargesModel {
  final int id;
  final double price;
  final int kilometer;
  final bool isActive;

  DeliveryChargesModel({
    required this.id,
    required this.price,
    required this.kilometer,
    required this.isActive,
  });

  // Factory method to create a DeliveryChargesModel from a JSON map
  factory DeliveryChargesModel.fromJson(Map<String, dynamic> json) {
    return DeliveryChargesModel(
      id: json['id'],
      price: json['price'].toDouble(), // Ensure the price is a double
      kilometer: json['kilometer'],
      isActive: json['is_active'],
    );
  }
}
