class Requisition {
  final String id;
  final String lecturerId;
  final String? departmentId;
  final double hoursWorked;
  final double paymentRate;
  final double totalAmount;
  final List<String> coursesTaught;
  final String status;
  final DateTime submissionDate;
  final DateTime? paymentDate;
  final bool isUrgent;
  final String? departmentName;
  final String? lecturerName;

  Requisition({
    required this.id,
    required this.lecturerId,
    this.departmentId,
    required this.hoursWorked,
    required this.paymentRate,
    required this.totalAmount,
    required this.coursesTaught,
    required this.status,
    required this.submissionDate,
    this.paymentDate,
    required this.isUrgent,
    this.departmentName,
    this.lecturerName,
  });

  factory Requisition.fromJson(Map<String, dynamic> json) {
    return Requisition(
      id: json['id'] as String,
      lecturerId: json['lecturer_id'] as String,
      departmentId: json['department_id'] as String?,
      hoursWorked: (json['hours_worked'] as num).toDouble(),
      paymentRate: (json['payment_rate'] as num).toDouble(),
      totalAmount: (json['total_amount'] as num).toDouble(),
      coursesTaught: List<String>.from(json['courses_taught'] as List),
      status: json['status'] as String,
      submissionDate: DateTime.parse(json['submission_date'] as String),
      paymentDate: json['payment_date'] != null 
          ? DateTime.parse(json['payment_date'] as String)
          : null,
      isUrgent: json['is_urgent'] as bool,
      departmentName: json['department'] != null 
          ? (json['department'] as Map)['name'] as String?
          : null,
      lecturerName: json['lecturer'] != null
          ? (json['lecturer'] as Map)['full_name'] as String?
          : null,
    );
  }
}