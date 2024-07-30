import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vazifa30/services/app_servise.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ApiService apiService;

  ProductBloc(this.apiService) : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<AddProduct>(_onAddProduct);
    on<UpdateProduct>(_onUpdateProduct);
    on<DeleteProduct>(_onDeleteProduct);
  }

  void _onLoadProducts(LoadProducts event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final products = await apiService.getProducts();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError('Failed to load products'));
    }
  }

  void _onAddProduct(AddProduct event, Emitter<ProductState> emit) async {
    try {
      await apiService.createProduct(event.product);
      add(LoadProducts());
    } catch (e) {
      emit(ProductError('Failed to add product'));
    }
  }

  void _onUpdateProduct(UpdateProduct event, Emitter<ProductState> emit) async {
    try {
      await apiService.updateProduct(event.product);
      add(LoadProducts());
    } catch (e) {
      emit(ProductError('Failed to update product'));
    }
  }

  void _onDeleteProduct(DeleteProduct event, Emitter<ProductState> emit) async {
    try {
      await apiService.deleteProduct(event.id);
      add(LoadProducts());
    } catch (e) {
      emit(ProductError('Failed to delete product'));
    }
  }
}