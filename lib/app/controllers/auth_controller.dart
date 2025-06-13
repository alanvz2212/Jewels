import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:testapp/app/widgets/custom_snackbar.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var isLoading = false.obs;
  var verificationId = ''.obs;
  Rx<User?> user = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    user.bindStream(_auth.authStateChanges());
  }

  Future<void> startSignup({
    required String email,
    required String password,
    required String username,
    required String phone,
  }) async {
    try {
      isLoading.value = true;

      // Validate email
      if (!GetUtils.isEmail(email)) {
        throw 'Invalid email format';
      }

      // Format and validate phone
      final formattedPhone = formatIndianPhoneNumber(phone);

      // Check if email/phone already exists
      if (await isEmailTaken(email)) {
        throw 'Email already in use';
      }
      if (await isPhoneTaken(formattedPhone)) {
        throw 'Phone number already in use';
      }

      // Create user with email/password first
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Send OTP to phone
      await _auth.verifyPhoneNumber(
        phoneNumber: formattedPhone,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification completed (rare on iOS)
          await _completeSignup(
            credential: credential,
            uid: userCredential.user!.uid,
            username: username,
            email: email,
            phone: formattedPhone,
          );
        },
        verificationFailed: (FirebaseAuthException e) {
          showCustomSnackbar(title: '', message: 'Verification Failed!');
          _auth.currentUser?.delete(); // Clean up if verification fails
        },
        codeSent: (String vId, int? resendToken) {
          verificationId.value = vId;
          Get.toNamed(
            '/verify-otp',
            arguments: {
              'uid': userCredential.user?.uid,
              'username': username,
              'email': email,
              'phone': formattedPhone,
              'password': password,
            },
          );
        },
        codeAutoRetrievalTimeout: (String vId) {
          verificationId.value = vId;
        },
      );
    } catch (e) {
      showCustomSnackbar(title: '', message: 'Error, e.toString()');
      // Clean up if anything fails
      if (_auth.currentUser != null) {
        await _auth.currentUser?.delete();
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Verify OTP for signup
  Future<void> verifySignupOTP(
    String otp,
    Map<String, dynamic> userData,
  ) async {
    try {
      isLoading.value = true;

      PhoneAuthCredential phoneCredential = PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: otp,
      );

      await _completeSignup(
        credential: phoneCredential,
        uid: userData['uid'],
        username: userData['username'],
        email: userData['email'],
        phone: userData['phone'],
      );
    } catch (e) {
      showCustomSnackbar(title: '', message: 'Invalid OTP');
      if (_auth.currentUser != null) {
        await _auth.currentUser?.delete();
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Resend OTP
  Future<void> resendOTP(Map<String, dynamic> userData) async {
    try {
      isLoading.value = true;

      await _auth.verifyPhoneNumber(
        phoneNumber: userData['phone'],
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _completeSignup(
            credential: credential,
            uid: userData['uid'],
            username: userData['username'],
            email: userData['email'],
            phone: userData['phone'],
          );
        },
        verificationFailed: (FirebaseAuthException e) {
          showCustomSnackbar(
            title: '',
            message: 'Error, e.message ?? Failed to resend OTP',
          );
        },
        codeSent: (String vId, int? resendToken) {
          verificationId.value = vId;
          showCustomSnackbar(title: '', message: 'OTP Sen Succesfully!');
        },
        codeAutoRetrievalTimeout: (String vId) {
          verificationId.value = vId;
        },
      );
    } catch (e) {
      showCustomSnackbar(title: '', message: 'Error, Failed to resend OTP');
    } finally {
      isLoading.value = false;
    }
  }

  // Helper method to complete signup
  Future<void> _completeSignup({
    required PhoneAuthCredential credential,
    required String uid,
    required String username,
    required String email,
    required String phone,
  }) async {
    try {
      // Link phone credential with email account
      await _auth.currentUser?.linkWithCredential(credential);

      // Save user data to Firestore
      await _firestore.collection('users').doc(uid).set({
        'username': username,
        'email': email,
        'phone': phone,
        'createdAt': FieldValue.serverTimestamp(),
        'isNewUser': true,
      });

      showCustomSnackbar(
        title: '',
        message: 'Success. Account created successfully',
      );
      Get.offAllNamed('/home');
    } catch (e) {
      showCustomSnackbar(title: '', message: 'Verification Failed!');
      ('Error', 'Failed to complete signup');
      throw e;
    }
  }

  // Format phone number to E.164 format for India /////////////////////////////
  String formatIndianPhoneNumber(String phone) {
    String digits = phone.replaceAll(RegExp(r'[^\d]'), '');
    // Remove leading zeros
    digits = digits.replaceAll(RegExp(r'^0+'), '');
    // Ensure 10 digits for Indian numbers
    if (digits.length > 10) {
      digits = digits.substring(digits.length - 10);
    }
    return '+91$digits';
  }

  // Check if email exists
  Future<bool> isEmailTaken(String email) async {
    try {
      // ignore: deprecated_member_use
      final methods = await _auth.fetchSignInMethodsForEmail(email);
      return methods.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Check if phone exists
  Future<bool> isPhoneTaken(String phone) async {
    //////////////////////////
    try {
      final formattedPhone = formatIndianPhoneNumber(phone);
      final querySnapshot = await _firestore
          .collection('users')
          .where('phone', isEqualTo: formattedPhone)
          .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Login with Email and Password
  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.offAllNamed('/home');
    } on FirebaseAuthException {
      showCustomSnackbar(title: '', message: 'Login Failed!');
    } finally {
      isLoading.value = false;
    }
  }

  // Phone Login Method
  Future<void> loginWithPhone(String phone) async {
    ////////////////////////////////
    try {
      isLoading.value = true;
      final formattedPhone = formatIndianPhoneNumber(phone);

      await _auth.verifyPhoneNumber(
        phoneNumber: formattedPhone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _signInWithPhoneCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          showCustomSnackbar(title: '', message: 'Phone Verification Failed!');
        },
        codeSent: (String vId, int? resendToken) {
          verificationId.value = vId;
          Get.toNamed(
            '/verify-login-otp',
            arguments: {'phone': formattedPhone},
          );
        },
        codeAutoRetrievalTimeout: (String vId) {
          verificationId.value = vId;
        },
      );
    } catch (e) {
      showCustomSnackbar(title: '', message: 'Error, ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // Verify Phone Login OTP
  Future<void> verifyLoginOTP(String otp) async {
    try {
      isLoading.value = true;
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: otp,
      );
      await _signInWithPhoneCredential(credential);
    } catch (e) {
      showCustomSnackbar(title: '', message: 'Invalid OTP');
    } finally {
      isLoading.value = false;
    }
  }

  // Helper method to sign in with phone credential
  Future<void> _signInWithPhoneCredential(
    PhoneAuthCredential credential,
  ) async {
    try {
      final userCredential = await _auth.signInWithCredential(credential);

      // Check if user exists in Firestore
      final userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user?.uid)
          .get();

      if (!userDoc.exists) {
        await _firestore.collection('users').doc(userCredential.user?.uid).set({
          'phone': userCredential.user?.phoneNumber,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      showCustomSnackbar(title: '', message: 'Login successful');
      Get.offAllNamed('/home');
    } catch (e) {
      showCustomSnackbar(
        title: '',
        message: 'Failed to sign in with phone number!',
      );
      throw e;
    }
  }

  // Combined Email and Phone Signup
  Future<void> signUpWithEmailAndPhone({
    required String email,
    required String password,
    required String username,
    required String phone,
  }) async {
    try {
      isLoading.value = true;

      if (!GetUtils.isEmail(email)) {
        ///////////////////////////////
        throw 'Invalid email format';
      }

      final formattedPhone = formatIndianPhoneNumber(phone);

      if (await isEmailTaken(email)) {
        throw 'Email already in use';
      }
      if (await isPhoneTaken(formattedPhone)) {
        throw 'Phone number already in use';
      }

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Send OTP to phone
      await _auth.verifyPhoneNumber(
        phoneNumber: formattedPhone,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _completeSignup(
            credential: credential,
            uid: userCredential.user!.uid,
            username: username,
            email: email,
            phone: formattedPhone,
          );
        },
        verificationFailed: (FirebaseAuthException e) {
          showCustomSnackbar(title: '', message: 'Verification Failed!');
          _auth.currentUser?.delete();
        },
        codeSent: (String vId, int? resendToken) {
          verificationId.value = vId;
          Get.toNamed(
            '/verify-otp',
            arguments: {
              'uid': userCredential.user?.uid,
              'username': username,
              'email': email,
              'phone': formattedPhone,
            },
          );
        },
        codeAutoRetrievalTimeout: (String vId) {
          verificationId.value = vId;
        },
      );
    } catch (e) {
      showCustomSnackbar(title: '', message: 'Error, ${e.toString()}');
      if (_auth.currentUser != null) {
        await _auth.currentUser?.delete();
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Verify OTP for Signup
  Future<void> verifyOTP(String otp, Map<String, String> userData) async {
    try {
      isLoading.value = true;

      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: otp,
      );

      await _completeSignup(
        credential: credential,
        uid: userData['uid']!,
        username: userData['username']!,
        email: userData['email']!,
        phone: userData['phone']!,
      );
    } catch (e) {
      showCustomSnackbar(title: '', message: 'Invalid OTP');
      if (_auth.currentUser != null) {
        await _auth.currentUser?.delete();
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      Get.offAllNamed('/login');
    } catch (e) {
      showCustomSnackbar(title: '', message: 'Failed To SignOut!');
    }
  }
}
