import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vazifa30/model/product_model.dart';
import 'package:vazifa30/services/app_servise.dart';
import '../../bloc/product_bloc.dart';
import '../../bloc/product_event.dart';

class AddEditProductPage extends StatefulWidget {
  final Product? product;

  const AddEditProductPage({super.key, this.product});

  @override
  State<AddEditProductPage> createState() => _AddEditProductPageState();
}

class _AddEditProductPageState extends State<AddEditProductPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.product?.title);
    _descriptionController =
        TextEditingController(text: widget.product?.description);
    _priceController =
        TextEditingController(text: widget.product?.price.toString() ?? '0.0');
    _imageUrl = widget.product?.images[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _imageUrl != null
                  ? Image.network(
                      _imageUrl!,
                      height: 200,
                    )
                  : const SizedBox.shrink(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: _pickImage,
                child: const Text(
                  'Pick Image',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: _saveProduct,
                child: Text(
                  widget.product == null ? 'Add' : 'Save',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final apiService = ApiService();
      final imageUrl = await apiService.uploadFile(pickedFile.path);
      setState(() {
        _imageUrl = imageUrl;
      });
    }
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      final product = Product(
        id: widget.product?.id ?? 0,
        title: _titleController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
        images: _imageUrl != null ? [_imageUrl!] : [],
      );
      if (widget.product == null) {
        context.read<ProductBloc>().add(AddProduct(product));
      } else {
        context.read<ProductBloc>().add(UpdateProduct(product));
      }
      Navigator.pop(context);
    }
  }
}