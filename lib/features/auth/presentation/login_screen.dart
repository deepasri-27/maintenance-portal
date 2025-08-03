import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:maintenance_portal/core/constants/app_colors.dart';
import 'package:maintenance_portal/core/widgets/custom_button.dart';
import 'package:maintenance_portal/core/widgets/custom_text_field.dart';
import 'providers/login_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _engineerIdController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    // Clear any previous error when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LoginProvider>().clearError();
    });
  }

  @override
  void dispose() {
    _engineerIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final loginProvider = context.read<LoginProvider>();
      
      final success = await loginProvider.login(
        _engineerIdController.text,
        _passwordController.text,
      );

      if (success && mounted) {
        // Navigate to dashboard on successful login
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Stack(
              children: [
                // Top gradient
                Container(
                  height: constraints.maxHeight * 0.45,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFF6F00), Color(0xFFFFA726)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),

                // Bottom white card
                Positioned(
                  top: constraints.maxHeight * 0.28,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, -4),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Engineer ID field
                            CustomTextField(
                              controller: _engineerIdController,
                              label: "Engineer ID",
                              prefixIcon: Icons.person_outline,
                              validator: (value) =>
                                  value!.isEmpty ? 'Please enter Engineer ID' : null,
                            ),
                            const SizedBox(height: 16),
                            
                            // Password field
                            CustomTextField(
                              controller: _passwordController,
                              label: "Password",
                              isObscure: _obscure,
                              prefixIcon: Icons.lock_outline,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscure ? Icons.visibility : Icons.visibility_off,
                                ),
                                onPressed: () =>
                                    setState(() => _obscure = !_obscure),
                              ),
                              validator: (value) =>
                                  value!.isEmpty ? 'Password required' : null,
                            ),
                            const SizedBox(height: 12),
                            
                            // Forgot Password
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  // TODO: Implement forgot password functionality
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Contact administrator for password reset"),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Forgot Password?",
                                  style: TextStyle(color: AppColors.textLight),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // Error message
                            Consumer<LoginProvider>(
                              builder: (context, loginProvider, child) {
                                if (loginProvider.error != null) {
                                  return Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(12),
                                    margin: const EdgeInsets.only(bottom: 16),
                                    decoration: BoxDecoration(
                                      color: AppColors.error.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                                    ),
                                    child: Text(
                                      loginProvider.error!,
                                      style: const TextStyle(
                                        color: AppColors.error,
                                        fontSize: 14,
                                      ),
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                            
                            // Login button
                            Consumer<LoginProvider>(
                              builder: (context, loginProvider, child) {
                                return loginProvider.isLoading
                                    ? const SizedBox(
                                        height: 48,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      )
                                    : CustomButton(
                                        label: "Login",
                                        onPressed: _handleLogin,
                                      );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Header section with logo and welcome text
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 24, right: 24, top: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 28,
                          child: Icon(Icons.build_circle,
                              color: Colors.orange, size: 30),
                        ),
                        SizedBox(height: 32),
                        Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Welcome back to Maintenance Portal 👷",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
