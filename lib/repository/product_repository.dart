import 'dart:convert';
import 'dart:ffi';

import 'package:http/http.dart' as http;
import 'package:order_payments/model/product.dart';

class ProductRepository {
  Future<List<Products>> getAll(int skip) async {
    var url = 'https://dummyjson.com/products?limit=10&skip=$skip';
    final uri = Uri.parse(url);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body)['products'] as List;
      final result = json.map((e) {
        return Products(
            id: e['id'],
            title: e['title'],
            description: e['description'],
            price: e['price'],
            discountPercentage: double.parse(e['discountPercentage'].toString()),
            rating: double.parse(e['rating'].toString()),
            stock: e['stock'],
            brand: e['brand'],
            category: e['category'],
            thumbnail: e['thumbnail'],);
      }).toList();
      return result;
    } else {
      print("Something wrong  ${response.statusCode}");
      throw "Something wrong  ${response.statusCode}";
    }
  }




}


