import 'package:flutter/material.dart';
import 'package:srms/services/auth_service.dart';
import 'package:srms/widgets/common/auth_form.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    try {
      final authService = AuthService();
      await authService.signUpWithEmail(
        _emailController.text,
        _passwordController.text,
      );
      
      // Update user profile with name
      await authService.updateUserProfile({
        'full_name': _nameController.text,
      });
      
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: AuthForm(
            isLogin: false,
            formKey: _formKey,
            emailController: _emailController,
            passwordController: _passwordController,
            nameController: _nameController,
            isLoading: _isLoading,
            onSubmit: _submit,
          ),
        ),
      ),
    );
  }
}