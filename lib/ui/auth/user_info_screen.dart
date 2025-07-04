import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserInfoScreen extends StatelessWidget {
  final String email;
  final String provider;
  final String role;

  const UserInfoScreen({super.key, required this.email, required this.provider, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => context.push('/home'),
            icon: Icon(Icons.home_outlined),
          ),
        ],
      ),
      body: Column(children: [Text('판매자!!! ')]),
    );
  }
}
