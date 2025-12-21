import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'player_entry_screen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: _controller, decoration: InputDecoration(labelText: "Username")),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (AuthService.login(_controller.text)) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PlayerEntryScreen()));
                }
              }, 
              child: Text("Enter App")
            )
          ],
        ),
      ),
    );
  }
}