// import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:m_test_app_admin/app/data/product.dart';
// import '../models/product_model.dart';

// class ProductController extends GetxController {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final RxBool isLoading = false.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     initializeProducts();
//   }

//   Future<void> initializeProducts() async {
//     try {
//       isLoading.value = true;

//       // Check if products already exist
//       final productsSnapshot =
//           await _firestore.collection('products').limit(1).get();

//       if (productsSnapshot.docs.isEmpty) {
//         // If no products exist, add the initial products
//         await _addInitialProducts();
//       }
//     } catch (e) {
//       print('Error initializing products: $e');
//       Get.snackbar(
//         'Error',
//         'Failed to initialize products',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> _addInitialProducts() async {
//     final batch = _firestore.batch();

//     // Convert each product from your products list to the new format without ID
//     final initialProducts = products
//         .map((product) => Product(
//               name: product.name,
//               description: product.description,
//               price: product.price,
//               imageUrls: product.imageUrls,
//               category: product.category,
//               rating: product.rating,
//               stock: product.stock,
//               material: product.material,
//               isFeatured: product.isFeatured,
//             ))
//         .toList();

//     // Add each product to the batch
//     for (var product in initialProducts) {
//       final docRef = _firestore.collection('products').doc();
//       batch.set(docRef, product.toMap());
//     }

//     // Commit the batch
//     await batch.commit().then((_) {
//       print('Successfully initialized ${initialProducts.length} products');
//     }).catchError((error) {
//       print('Error in batch commit: $error');
//     });
//   }

//   // Method to fetch all products
//   Future<List<Product>> getAllProducts() async {
//     try {
//       final QuerySnapshot snapshot =
//           await _firestore.collection('products').get();

//       return snapshot.docs.map((doc) {
//         return Product.fromMap(
//           doc.data() as Map<String, dynamic>,
//           id: doc.id,
//         );
//       }).toList();
//     } catch (e) {
//       print('Error fetching products: $e');
//       return [];
//     }
//   }

//   // Method to fetch featured products
//   Future<List<Product>> getFeaturedProducts() async {
//     try {
//       final QuerySnapshot snapshot = await _firestore
//           .collection('products')
//           .where('isFeatured', isEqualTo: true)
//           .get();

//       return snapshot.docs.map((doc) {
//         return Product.fromMap(
//           doc.data() as Map<String, dynamic>,
//           id: doc.id,
//         );
//       }).toList();
//     } catch (e) {
//       print('Error fetching featured products: $e');
//       return [];
//     }
//   }

//   // Method to fetch products by category
//   Future<List<Product>> getProductsByCategory(String category) async {
//     try {
//       final QuerySnapshot snapshot = await _firestore
//           .collection('products')
//           .where('category', isEqualTo: category)
//           .get();

//       return snapshot.docs.map((doc) {
//         return Product.fromMap(
//           doc.data() as Map<String, dynamic>,
//           id: doc.id,
//         );
//       }).toList();
//     } catch (e) {
//       print('Error fetching products by category: $e');
//       return [];
//     }
//   }
// }
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jewels/app/data/product.dart';
import '../models/product_model.dart';

class ProductController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxBool isLoading = false.obs;
  final RxList<Product> productsList = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    // initializeProducts();
    fetchProducts();
  }

  Future<void> initializeProducts() async {
    try {
      isLoading.value = true;

      final productsSnapshot = await _firestore
          .collection('products')
          .limit(1)
          .get();

      if (productsSnapshot.docs.isEmpty) {
        await _addInitialProducts();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing products: $e');
      }
      Get.snackbar(
        'Error',
        'Failed to initialize products',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      final QuerySnapshot snapshot = await _firestore
          .collection('products')
          .get();

      productsList.value = snapshot.docs.map((doc) {
        return Product.fromMap(doc.data() as Map<String, dynamic>, id: doc.id);
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching products: $e');
      }
      Get.snackbar(
        'Error',
        'Failed to fetch products',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _addInitialProducts() async {
    final batch = _firestore.batch();

    final initialProducts = products
        .map(
          (product) => Product(
            name: product.name,
            description: product.description,
            price: product.price,
            imageUrls: product.imageUrls,
            category: product.category,
            rating: product.rating,
            stock: product.stock,
            material: product.material,
            isFeatured: product.isFeatured,
          ),
        )
        .toList();

    for (var product in initialProducts) {
      final docRef = _firestore.collection('products').doc();
      batch.set(docRef, product.toMap());
    }

    await batch
        .commit()
        .then((_) {
          if (kDebugMode) {
            print(
              'Successfully initialized ${initialProducts.length} products',
            );
          }
        })
        .catchError((error) {
          if (kDebugMode) {
            print('Error in batch commit: $error');
          }
        });
  }

  List<Product> getFeaturedProducts() {
    return productsList.where((product) => product.isFeatured).toList();
  }

  List<Product> getProductsByCategory(String category) {
    return productsList
        .where((product) => product.category == category)
        .toList();
  }
}
