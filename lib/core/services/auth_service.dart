import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

/// ============================================================================
/// FILE: auth_service.dart
/// MODULE: Core Services (Authentication Service Layer)
/// PROJECT: Constructa App - College Project
/// DESCRIPTION:
///   Provides backend authentication services for the Constructa application.
///   Integrates Firebase Authentication, Google Sign-In SDK, Cloud Firestore,
///   and Firebase Storage for complete user account lifecycle management.
/// ============================================================================

/// Service class handling all Firebase Authentication and user data logic.
///
/// Key Capabilities:
/// - User Login via Email/Password & Google OAuth SSO
/// - User Signup and automatic Firestore profile document creation
/// - Profile image upload to Firebase Storage
/// - Session lifecycle management (logout, password reset, active user stream)
class AuthService {
  /// Instance of Firebase Authentication backend service.
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Instance of Cloud Firestore database service.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Instance of Firebase Storage service for media storage.
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Instance of Google Sign-In SDK handler.
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // ---------------------------------------------------------------------------
  // SESSION & USER STATE ACCESSORS
  // ---------------------------------------------------------------------------

  /// Returns the currently authenticated Firebase user ([User]), or `null` if unauthenticated.
  User? get currentUser => _auth.currentUser;

  // ---------------------------------------------------------------------------
  // AUTHENTICATION: LOGIN & GOOGLE SIGN-IN SECTION
  // ---------------------------------------------------------------------------

  /// Authenticates an existing user using Email and Password.
  ///
  /// Parameters:
  /// - [email]: User's registered email address.
  /// - [password]: User's account password.
  ///
  /// Returns:
  ///   A [Future] containing [UserCredential] on successful authentication.
  ///
  /// Throws:
  ///   Rethrows [FirebaseAuthException] if credentials are invalid or user not found.
  Future<UserCredential?> login({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Authenticates a user using Google OAuth Single Sign-On (SSO).
  ///
  /// Workflow:
  /// 1. Prompts the user with the native Google OAuth login flow.
  /// 2. Extracts `accessToken` and `idToken` from [GoogleSignInAuthentication].
  /// 3. Authenticates with Firebase Auth using [GoogleAuthProvider.credential].
  /// 4. Checks Cloud Firestore (`users` collection) for an existing user record.
  /// 5. If first-time login, provisions a new [UserModel] in Firestore with role 'customer'.
  ///
  /// Returns:
  ///   A [Future] containing [UserCredential] if successful, or `null` if user cancels sign-in.
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);

      // Save user info to Firestore if it's a new user
      if (userCredential.user != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(userCredential.user!.uid).get();

        if (!userDoc.exists) {
          UserModel userModel = UserModel(
            uid: userCredential.user!.uid,
            email: userCredential.user!.email ?? '',
            fullName: userCredential.user!.displayName ?? 'New User',
            phoneNumber: userCredential.user!.phoneNumber ?? '',
            role: 'customer',
            profileImageUrl: userCredential.user!.photoURL ?? '',
          );

          await _firestore.collection('users').doc(userCredential.user!.uid).set(userModel.toMap());
        }
      }

      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  /// Signs out the current user session from both Google Sign-In and Firebase Auth.
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  /// Sends a password reset email to the specified [email] address.
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // ---------------------------------------------------------------------------
  // AUTHENTICATION: SIGNUP & USER PROFILE SECTION
  // ---------------------------------------------------------------------------

  /// Uploads a user profile image file to Firebase Storage under `profile_images/{uid}.jpg`.
  ///
  /// Returns the public download URL string on success, or empty string on error.
  Future<String> uploadImage(File imageFile, String uid) async {
    try {
      Reference ref = _storage.ref().child('profile_images').child('$uid.jpg');
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("AuthService: Image upload error: $e");
      return '';
    }
  }

  /// Registers a new user with Email, Password, and extended profile attributes.
  ///
  /// Workflow:
  /// 1. Creates Firebase Auth user using [FirebaseAuth.createUserWithEmailAndPassword].
  /// 2. Uploads profile image to Firebase Storage (if provided).
  /// 3. Builds a [UserModel] instance and writes profile data to Cloud Firestore (`users` collection).
  ///
  /// Returns [UserCredential] on success, or throws Exception on failure.
  Future<UserCredential?> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    required String role,
    File? profileImage,
  }) async {
    try {
      print("AuthService: Attempting sign up for $email");
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("AuthService: User created in Firebase Auth with UID: ${userCredential.user?.uid}");

      if (userCredential.user != null) {
        String imageUrl = '';
        if (profileImage != null) {
          imageUrl = await uploadImage(profileImage, userCredential.user!.uid);
        }

        UserModel userModel = UserModel(
          uid: userCredential.user!.uid,
          email: email,
          fullName: fullName,
          phoneNumber: phoneNumber,
          role: role,
          profileImageUrl: imageUrl,
        );

        print("AuthService: Writing user data to Firestore 'users' collection...");
        try {
          await _firestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .set(userModel.toMap());
          print("AuthService: Successfully wrote user data to Firestore.");
        } catch (firestoreError) {
          print("AuthService: FAILED to write to Firestore: $firestoreError");
          throw Exception("Auth success, but Firestore failed: $firestoreError");
        }
      }

      return userCredential;
    } catch (e) {
      print("AuthService: General error in signUp: $e");
      rethrow;
    }
  }

  /// Updates the role string (e.g., 'customer' or 'constructor') for a given user UID in Firestore.
  Future<void> updateUserRole(String uid, String role) async {
    await _firestore.collection('users').doc(uid).update({'role': role});
  }

  /// Provides a real-time stream of the current authenticated user's [UserModel] document from Firestore.
  Stream<UserModel?> getUserData() {
    User? user = _auth.currentUser;
    if (user != null) {
      return _firestore
          .collection('users')
          .doc(user.uid)
          .snapshots()
          .map((snapshot) {
        if (snapshot.exists && snapshot.data() != null) {
          return UserModel.fromMap(snapshot.data()!);
        }
        return null;
      });
    }
    return Stream.value(null);
  }
}

