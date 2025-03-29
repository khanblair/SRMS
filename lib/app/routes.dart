import 'package:flutter/material.dart';
import 'package:srms/screens/auth/login_screen.dart';
import 'package:srms/screens/auth/register_screen.dart';
import 'package:srms/screens/dashboard/home_screen.dart';
import 'package:srms/screens/requisitions/create_requisition.dart';
import 'package:srms/screens/requisitions/requisition_detail.dart';
import 'package:srms/screens/requisitions/requisition_list.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/requisitions':
        return MaterialPageRoute(builder: (_) => const RequisitionListScreen());
      case '/requisitions/create':
        return MaterialPageRoute(builder: (_) => const CreateRequisitionScreen());
      case '/requisitions/detail':
        final args = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => RequisitionDetailScreen(requisitionId: args));
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}