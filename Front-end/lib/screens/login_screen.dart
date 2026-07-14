import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/app_header.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameFocus = FocusNode();
  final _passwordFocus = FocusNode();
  
  final _authService = AuthService();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _usernameFocus.addListener(() => setState(() {}));
    _passwordFocus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  // Device/site validation (the "Zero Trust" check) now happens
  // server-side as part of POST /api/v1/auth/login -- see
  // AuthService.deviceValidationService on the backend. An unrecognized
  // device comes back as an UNRECOGNIZED_DEVICE error below, same as
  // any other login failure.
  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      String? error = await _authService.login(
        _usernameController.text, 
        _passwordController.text
      );

      setState(() => _isLoading = false);

      // Navigate if successful, otherwise show error
      if (error == null) {
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/dashboard');
        }
      } else {
        setState(() {
          _errorMessage = error;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const AppHeader(triangleSize: 15, fontSize: 20),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const SizedBox(height: 64), 
              Image.asset(
                'lib/images/Professional Parking group Logo.jpg',
                height: 120,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 32), 
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 384),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Device ID: ${_authService.deviceId}", 
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      _field(
                        label: 'USERNAME',
                        controller: _usernameController,
                        focusNode: _usernameFocus,
                        obscure: false,
                      ),
                      const SizedBox(height: 24),
                      _field(
                        label: 'PASSWORD',
                        controller: _passwordController,
                        focusNode: _passwordFocus,
                        obscure: true,
                      ),
                      
                      // Error message display for handling
                      if (_errorMessage != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage!, 
                          style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                      
                      const SizedBox(height: 24),
                      
                      // Updated for a loading indicator
                      SizedBox(
                        height: 48,
                        child: _isLoading 
                          ? const Center(child: CircularProgressIndicator(color: AppColors.black))
                          : ElevatedButton(
                              onPressed: _handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.black,
                                foregroundColor: AppColors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ).copyWith(
                                backgroundColor: WidgetStateProperty.resolveWith(
                                  (states) => states.contains(WidgetState.pressed) ||
                                          states.contains(WidgetState.hovered)
                                      ? Colors.grey.shade800
                                      : AppColors.black,
                                ),
                              ),
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field({
    required String label,
    required TextEditingController controller,
    required FocusNode focusNode,
    required bool obscure,
  }) {
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
            color: AppColors.gray900,
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 48,
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            obscureText: obscure,
            validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              filled: true,
              fillColor: focusNode.hasFocus
                  ? AppColors.white
                  : AppColors.loginInputBg,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: AppColors.black, width: 1),
              ),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: AppColors.black, width: 1),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: AppColors.black, width: 1),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
