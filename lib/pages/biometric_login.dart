import 'package:flutter/material.dart';
import 'package:flutter_biometric_auth/pages/home_page.dart';
import 'package:flutter_biometric_auth/services/auth_service.dart';

class BiometricLogin extends StatefulWidget {
  const BiometricLogin({super.key});

  @override
  State<BiometricLogin> createState() => _BiometricLoginState();
}

class _BiometricLoginState extends State<BiometricLogin> {
  final AuthService _authService = AuthService();
  bool _isAuthenticating = false;

  Future<void> _handleBiometricAuth() async {
    setState(() {
      _isAuthenticating = true;
    });

    final (bool isAuthenticated, String? error) = await _authService
        .authenticateUser();

    setState(() {
      _isAuthenticating = false;
    });

    if (isAuthenticated) {
      // Navigate to the next screen
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      }
    } else
    // Show error message
    if (mounted && error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: .center,
          spacing: 30,
          children: [
            Icon(
              Icons.fingerprint_outlined,
              size: 60,
            ),
            Text(
              'Use your Biometric to login',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isAuthenticating ? null : _handleBiometricAuth,
                child: _isAuthenticating
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Login With Biometrics'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
