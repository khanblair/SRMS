import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:srms/config/supabase_config.dart';
import 'package:srms/models/requisition_model.dart';
import 'package:srms/models/document_model.dart';
import 'package:srms/state/auth_provider.dart';
import 'package:srms/widgets/common/document_card.dart';
import 'package:srms/widgets/ui/empty_state.dart';

class RequisitionDetailScreen extends StatefulWidget {
  final String requisitionId;

  const RequisitionDetailScreen({super.key, required this.requisitionId});

  @override
  State<RequisitionDetailScreen> createState() => _RequisitionDetailScreenState();
}

class _RequisitionDetailScreenState extends State<RequisitionDetailScreen> {
  Requisition? _requisition;
  List<Document> _documents = [];
  bool _isLoading = true;
  bool _isApproving = false;
  bool _isRejecting = false;

  @override
  void initState() {
    super.initState();
    _fetchRequisition();
    _fetchDocuments();
  }

  Future<void> _fetchRequisition() async {
    try {
      final response = await SupabaseConfig.client
          .from('requisitions')
          .select('*, department:departments(*), lecturer:users(*)')
          .eq('id', widget.requisitionId)
          .single();
      
      setState(() {
        _requisition = Requisition.fromJson(response);
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading requisition: $e')),
      );
    }
  }

  Future<void> _fetchDocuments() async {
    try {
      final response = await SupabaseConfig.client
          .from('documents')
          .select('*, type:document_types(*)')
          .eq('requisition_id', widget.requisitionId);
      
      setState(() {
        _documents = response.map((json) => Document.fromJson(json)).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading documents: $e')),
      );
    }
  }

  Future<void> _updateStatus(String status) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.user?.id;
    if (userId == null) return;

    try {
      setState(() {
        if (status == 'approved') _isApproving = true;
        if (status == 'rejected') _isRejecting = true;
      });

      await SupabaseConfig.client
          .from('requisitions')
          .update({'status': status})
          .eq('id', widget.requisitionId);

      // Create approval record
      final stageResponse = await SupabaseConfig.client
          .from('approval_stages')
          .select('id')
          .eq('role_required', authProvider.userRole ?? '')
          .single();
          
      await SupabaseConfig.client.from('requisition_approvals').insert({
        'requisition_id': widget.requisitionId,
        'stage_id': stageResponse['id'],
        'approver_id': userId,
        'status': status == 'approved' ? 'approved' : 'rejected',
      });

      await _fetchRequisition();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating status: $e')),
      );
    } finally {
      setState(() {
        _isApproving = false;
        _isRejecting = false;
      });
    }
  }

  void _navigateToDocumentUpload() {
    Navigator.pushNamed(
      context, 
      '/documents/upload', 
      arguments: widget.requisitionId
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_requisition == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Requisition Details')),
        body: const EmptyState(
          icon: Icons.error,
          message: 'Requisition not found',
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Requisition Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Requisition Summary
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'KES ${_requisition!.totalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Chip(
                          label: Text(
                            _requisition!.status.toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: _requisition!.status == 'approved'
                              ? Colors.green
                              : _requisition!.status == 'rejected'
                                  ? Colors.red
                                  : Colors.orange,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_requisition!.hoursWorked} hours @ KES ${_requisition!.paymentRate}/hour',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    if (_requisition!.departmentName != null)
                      Text(
                        'Department: ${_requisition!.departmentName}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    if (_requisition!.lecturerName != null)
                      Text(
                        'Lecturer: ${_requisition!.lecturerName}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    const SizedBox(height: 8),
                    Text(
                      'Submitted: ${_requisition!.submissionDate.toLocal().toString().split(' ')[0]}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (_requisition!.paymentDate != null)
                      Text(
                        'Paid: ${_requisition!.paymentDate!.toLocal().toString().split(' ')[0]}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Courses Taught
            const Text(
              'Courses Taught',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _requisition!.coursesTaught
                  .map((course) => Chip(label: Text(course)))
                  .toList(),
            ),
            const SizedBox(height: 24),

            // Documents Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Supporting Documents',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (authProvider.isLecturer)
                  TextButton.icon(
                    icon: const Icon(Icons.upload),
                    label: const Text('Add Document'),
                    onPressed: _navigateToDocumentUpload,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            _documents.isEmpty
                ? const EmptyState(
                    icon: Icons.folder_open,
                    message: 'No documents uploaded',
                    small: true,
                  )
                : Column(
                    children: _documents
                        .map((doc) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: DocumentCard(document: doc),
                            ))
                        .toList(),
                  ),
            const SizedBox(height: 24),

            // Approval Actions (for approvers)
            if (authProvider.isHod || authProvider.isAdmin)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Approval Actions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: _isApproving
                              ? const CircularProgressIndicator()
                              : const Icon(Icons.check),
                          label: const Text('Approve'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: _isApproving || _isRejecting
                              ? null
                              : () => _updateStatus('approved'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: _isRejecting
                              ? const CircularProgressIndicator()
                              : const Icon(Icons.close),
                          label: const Text('Reject'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: _isApproving || _isRejecting
                              ? null
                              : () => _updateStatus('rejected'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}