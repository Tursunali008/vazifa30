import 'package:dio/dio.dart';
import 'package:vazifa30/model/product_model.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://api.escuelajs.co/api/v1'));

  Future<List<Product>> getProducts() async {
    try {
      final response = await _dio.get('/products');
      return (response.data as List).map((e) => Product.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to load products');
    }
  }

  Future<void> createProduct(Product product) async {
    try {
      await _dio.post('/products', data: product.toJson());
    } catch (e) {
      throw Exception('Failed to create product');
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      await _dio.put('/products/${product.id}', data: product.toJson());
    } catch (e) {
      throw Exception('Failed to update product');
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await _dio.delete('/products/$id');
    } catch (e) {
      throw Exception('Failed to delete product');
    }
  }

  Future<String> uploadFile(String filePath) async {
    try {
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
      });
      final response = await _dio.post('/files/upload', data: formData);
      return response.data['location'];
    } catch (e) {
      throw Exception('Failed to upload file');
    }
  }
}