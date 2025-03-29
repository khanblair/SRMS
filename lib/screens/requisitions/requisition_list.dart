import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:srms/config/supabase_config.dart';
import 'package:srms/models/requisition_model.dart';
import 'package:srms/state/auth_provider.dart';
import 'package:srms/widgets/common/requisition_card.dart';
import 'package:srms/widgets/ui/empty_state.dart';

class RequisitionListScreen extends StatefulWidget {
  const RequisitionListScreen({super.key});

  @override
  State<RequisitionListScreen> createState() => _RequisitionListScreenState();
}

class _RequisitionListScreenState extends State<RequisitionListScreen> {
  List<Requisition> _requisitions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRequisitions();
  }

  Future<void> _fetchRequisitions() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.user?.id;
    if (userId == null) return;

    try {
      final query = SupabaseConfig.client
          .from('requisitions')
          .select('*, department:departments(*), lecturer:users(*)');
      
      if (authProvider.isLecturer) {
        query.eq('lecturer_id', userId);
      } else if (authProvider.isHod) {
        // Fetch department ID for HOD from users table
        final departmentResponse = await SupabaseConfig.client
            .from('users')
            .select('department_id')
            .eq('id', userId)
            .single();
        
        query.eq('department_id', departmentResponse['department_id'] ?? '');
      }

      final data = await query.order('created_at', ascending: false);
      
      setState(() {
        _requisitions = data.map((json) => Requisition.fromJson(json)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching requisitions: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_requisitions.isEmpty) {
      return EmptyState(
        icon: Icons.request_page,
        message: 'No requisitions found',
        actionText: 'Create New Requisition',
        onAction: () {
          Navigator.pushNamed(context, '/requisitions/create');
        },
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchRequisitions,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _requisitions.length,
        itemBuilder: (context, index) {
          final requisition = _requisitions[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: RequisitionCard(
              requisition: requisition,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/requisitions/detail',
                  arguments: requisition.id,
                );
              },
            ),
          );
        },
      ),
    );
  }
}