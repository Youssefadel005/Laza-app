import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore_service.dart'; // <--- 1. IMPORT THIS

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Create an instance of your service
  final FirestoreService _firestoreService = FirestoreService(); 
  bool _isLoading = false;

  Future<void> _handleAuth(bool isLogin) async {
    setState(() => _isLoading = true);
    try {
      if (isLogin) {
        // --- LOGIN LOGIC ---
        await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passController.text.trim(),
        );
      } else {
        // --- SIGN UP LOGIC (Modified) ---
        
        // 1. Create the user in Authentication
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passController.text.trim(),
        );

        // 2. SAVE TO FIRESTORE "users" COLLECTION
        if (credential.user != null) {
          await _firestoreService.createUserProfile(credential.user!);
        }
      }

      // 3. Navigate to Home
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_bag, size: 80, color: Color(0xFF9775FA)),
            const SizedBox(height: 20),
            const Text("Laza", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            TextField(
              key: const Key('email_field'),
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              key: const Key('password_field'),
              controller: _passController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 30),
            _isLoading 
                ? const CircularProgressIndicator()
                : Column(
                    children: [
                      ElevatedButton(
                        key: const Key('login_button'),
                        onPressed: () => _handleAuth(true), // Login Mode
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: const Color(0xFF9775FA),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Login"),
                      ),
                      TextButton(
                        onPressed: () => _handleAuth(false), // Signup Mode
                        child: const Text("Create Account"),
                      ),
                    ],
                  )
          ],
        ),
      ),
    );
  }
}