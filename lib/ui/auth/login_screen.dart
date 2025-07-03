import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () => context.pushReplacement('/home'), icon: Icon(Icons.home))
        ],
      ),
      body: Column(
        children: [

        ],
      ),
    );
  }
  
}