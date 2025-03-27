import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lecturer_requisition/state/auth_provider.dart';
import 'package:lecturer_requisition/widgets/charts/hours_chart.dart';
import 'package:lecturer_requisition/widgets/charts/payments_chart.dart';
import 'package:lecturer_requisition/services/analytics_service.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  Map<String, dynamic> _metrics = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMetrics();
  }

  Future<void> _loadMetrics() async {
    final authProvider = context.read<AuthProvider>();
    final userId = authProvider.user?.id;
    if (userId == null) return;

    try {
      final analyticsService = AnalyticsService();
      final metrics = await analyticsService.getLecturerMetrics(userId);
      setState(() {
        _metrics = metrics;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load metrics: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final userId = authProvider.user?.id;

    return Scaffold(
      appBar: AppBar(title: const Text('Performance Analytics')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Hours Worked',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 250,
                            child: HoursChart.withData(_metrics['hours_data'] ?? []),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Payments Received',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 250,
                            child: PaymentsChart.withData(_metrics['payments_data'] ?? []),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (authProvider.isLecturer) ...[
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Performance Metrics',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ListTile(
                              leading: const Icon(Icons.timelapse),
                              title: const Text('Average Approval Time'),
                              trailing: Text(
                                '${_metrics['avg_approval_time'] ?? 'N/A'} days',
                              ),
                            ),
                            ListTile(
                              leading: const Icon(Icons.check_circle),
                              title: const Text('Approval Rate'),
                              trailing: Text(
                                '${_metrics['approval_rate'] ?? 'N/A'}%',
                              ),
                            ),
                            ListTile(
                              leading: const Icon(Icons.monetization_on),
                              title: const Text('Total Earnings'),
                              trailing: Text(
                                'KES ${_metrics['total_earnings']?.toStringAsFixed(2) ?? '0.00'}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                            if (_metrics['last_payment_date'] != null)
                              ListTile(
                                leading: const Icon(Icons.calendar_today),
                                title: const Text('Last Payment'),
                                trailing: Text(
                                  _metrics['last_payment_date'],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  if (authProvider.isHod || authProvider.isAdmin) ...[
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Department Overview',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ListTile(
                              leading: const Icon(Icons.people),
                              title: const Text('Active Lecturers'),
                              trailing: Text(
                                _metrics['active_lecturers']?.toString() ?? '0',
                              ),
                            ),
                            ListTile(
                              leading: const Icon(Icons.request_page),
                              title: const Text('Pending Requisitions'),
                              trailing: Text(
                                _metrics['pending_requisitions']?.toString() ?? '0',
                              ),
                            ),
                            ListTile(
                              leading: const Icon(Icons.attach_money),
                              title: const Text('Budget Utilization'),
                              trailing: Text(
                                '${_metrics['budget_utilization']?.toStringAsFixed(1) ?? '0'}%',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}