import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:srms/config/supabase_config.dart';
import 'package:srms/models/requisition_model.dart';
import 'package:srms/state/auth_provider.dart';
import 'package:srms/widgets/forms/requisition_form.dart';

class CreateRequisitionScreen extends StatefulWidget {
  const CreateRequisitionScreen({super.key});

  @override
  State<CreateRequisitionScreen> createState() => _CreateRequisitionScreenState();
}

class _CreateRequisitionScreenState extends State<CreateRequisitionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _hoursController = TextEditingController();
  final _rateController = TextEditingController();
  final _coursesController = TextEditingController();
  bool _isUrgent = false;
  bool _isSubmitting = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isSubmitting = true);
    
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.user?.id;
      if (userId == null) return;

      // Get department ID from user
      final userData = await SupabaseConfig.client
          .from('users')
          .select('department_id')
          .eq('id', userId)
          .single();
          
      final departmentId = userData['department_id'] as String?;
      if (departmentId == null) {
        throw Exception('User not assigned to a department');
      }

      final requisition = {
        'lecturer_id': userId,
        'department_id': departmentId,
        'hours_worked': double.parse(_hoursController.text),
        'payment_rate': double.parse(_rateController.text),
        'courses_taught': _coursesController.text.split(',').map((e) => e.trim()).toList(),
        'status': 'draft',
        'is_urgent': _isUrgent,
      };

      await SupabaseConfig.client.from('requisitions').insert(requisition);
      
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating requisition: $e')),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Requisition'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _submit,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: RequisitionForm(
            hoursController: _hoursController,
            rateController: _rateController,
            coursesController: _coursesController,
            isUrgent: _isUrgent,
            onUrgentChanged: (value) => setState(() => _isUrgent = value),
          ),
        ),
      ),
    );
  }
}