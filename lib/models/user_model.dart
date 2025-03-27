class AppUser {
  final String id;
  final String email;
  final String role;
  final String fullName;
  final String? phoneNumber;
  final String? departmentId;
  final String? bio;
  final String? avatarUrl;
  final bool isActive;
  final bool darkModeEnabled;

  AppUser({
    required this.id,
    required this.email,
    required this.role,
    required this.fullName,
    this.phoneNumber,
    this.departmentId,
    this.bio,
    this.avatarUrl,
    this.isActive = true,
    this.darkModeEnabled = false,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      fullName: json['full_name'] as String,
      phoneNumber: json['phone_number'] as String?,
      departmentId: json['department_id'] as String?,
      bio: json['bio'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      darkModeEnabled: json['dark_mode_enabled'] as bool? ?? false,
    );
  }
}