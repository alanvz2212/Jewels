import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:testapp/models/product_model.dart';

class ProductContorller extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxBool isLoading = false.obs;
  final RxList<Product> productsList = <Product>[].obs;
  final RxList<String> categories = <String>[].obs;
  final RxString selectedCategory = ''.obs;

  @override
  void onInit() {
    super.onInit();
    initializeData();
  }

  Future<void> initializeData() async {
    try {
      isLoading.value = true;
      selectedCategory.value = '';
      await fetchCatergories();
      await fetchProducts();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCatergories() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('products')
          .get();
      final Set<String> uniqueCategories = snapshot.docs
          .map(
            (doc) => (doc.data() as Map<String, dynamic>)['category'] as String,
          )
          .where((category) => category.isNotEmpty)
          .toSet();
      categories.value = ['All Products', ...uniqueCategories.toList()..sort()];
    } catch (e) {
      if (kDebugMode) {
        print('Error Fetching Categories');
      }
    }
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      Query query = _firestore.collection('Products');
      if (selectedCategory.value.isEmpty) {
        query = query.where('category', isEqualTo: selectedCategory.value);
      }
      final QuerySnapshot snapshot = await query.get();
      productsList.value = snapshot.docs.map((doc) {
        return Product.fromMap(doc.data() as Map<String, dynamic>, id: doc.id);
      }).toList();
    } catch (e) {
      // if (kDebugMode) {
      //   print('Error Fetching Products');
      // }
    } finally {
      isLoading.value = false;
    }
  }
}
