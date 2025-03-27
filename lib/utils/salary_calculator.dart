class SalaryCalculator {
  static double calculateSalary({
    required double hoursWorked,
    required double ratePerHour,
    double taxPercentage = 0.05,
  }) {
    final grossSalary = hoursWorked * ratePerHour;
    final taxAmount = grossSalary * taxPercentage;
    return grossSalary - taxAmount;
  }

  static String formatSalary(double amount) {
    return 'KES ${amount.toStringAsFixed(2)}';
  }

  static String estimateSalary({
    required int expectedHours,
    required double ratePerHour,
    double taxPercentage = 0.05,
  }) {
    final salary = calculateSalary(
      hoursWorked: expectedHours.toDouble(),
      ratePerHour: ratePerHour,
      taxPercentage: taxPercentage,
    );
    return formatSalary(salary);
  }
}