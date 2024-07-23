import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ecommerce/controllers/Database_Controller.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/views/widgets/drop_down_menu.dart';
import 'package:ecommerce/views/widgets/main_button.dart';
import 'package:provider/provider.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  int price = 0;
  String imageUrl = '';
  int discountValue = 0;
  String category = 'clothes';
  File? image;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage(File image) async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('images/${DateTime.now().toIso8601String()}');
    final uploadTask = await storageRef.putFile(image);
    imageUrl = await storageRef.getDownloadURL();
  }

  Future<void> _addProduct(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (image != null) {
        await _uploadImage(image!);
      }

      final product = Product(
        id: DateTime.now().toIso8601String(),
        title: title,
        price: price,
        imageUrl: imageUrl,
        discountValue: discountValue,
        category: category,
        rate: 0,
      );

      final database = Provider.of<FirestoreDatabase>(context, listen: false);
      await database.addProduct(product);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a title' : null,
                onSaved: (value) => title = value!,
              ),
              const SizedBox(height: 12.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Price',
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a price' : null,
                onSaved: (value) => price = int.parse(value!),
              ),
              const SizedBox(height: 12.0),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: image == null
                      ? const Center(child: Text('Tap to pick an image'))
                      : Image.file(image!),
                ),
              ),
              const SizedBox(height: 12.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Discount Value',
                ),
                keyboardType: TextInputType.number,
                onSaved: (value) =>
                    discountValue = value!.isEmpty ? 0 : int.parse(value),
              ),
              const SizedBox(height: 12.0),
              DropDownMenuComponent(
                onChanged: (value) {
                  setState(() {
                    category = value!;
                  });
                },
                items: const [
                  'Clothes',
                  'Electronics',
                  'Accessories',
                  'Others'
                ],
                hint: 'Clothes',
                icon: const Icon(Icons.arrow_drop_down),
              ),
              const SizedBox(height: 24.0),
              MainButton(
                text: 'Add Product',
                onTap: () => _addProduct(context),
                color: Colors.green,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
