import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ovouser/api/api_urls.dart';
import 'package:ovouser/models/shops_products.dart';

class ApiService {
  Future<List<ShopProductModel>> fetchShopsWithProducts() async {
    final response = await http.get(Uri.parse(APIUrls.shopsProducts));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> shopsData = jsonResponse['data']['shops']['data'];
      return shopsData.map((json) => ShopProductModel.fromJson(json)).toList();
    } else {
      throw Exception(
          'Failed to load shops and products: ${response.statusCode}');
    }
  }
}