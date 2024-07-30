import 'package:flutter/foundation.dart';
import 'package:vazifa30/model/product_model.dart';

@immutable
abstract class ProductEvent {}

class LoadProducts extends ProductEvent {}

class AddProduct extends ProductEvent {
  final Product product;

  AddProduct(this.product);
}

class UpdateProduct extends ProductEvent {
  final Product product;

  UpdateProduct(this.product);
}

class DeleteProduct extends ProductEvent {
  final int id;

  DeleteProduct(this.id);
}