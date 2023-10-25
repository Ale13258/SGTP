import 'dart:js';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:register/main.dart';

class LoginScreen extends StatelessWidget {
  final _NameController = TextEditingController();
  final _PasswordController = TextEditingController();

  void _login() async {
    final response = await http.post(
      Uri.parse(
          'http://localhost:4000/login'), // URL de la API de inicio de sesión
      body: {
        'Name': _NameController.text,
        'Password': _PasswordController.text,
      },
    );

    if (response.statusCode == 200) {
      // Inicio de sesión exitoso, puedes realizar la redirección aquí
      Navigator.of(context as BuildContext).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>
              inicio(), // Reemplaza 'HomeScreen' con el nombre de tu pantalla de inicio
        ),
      );
    } else {
      // Inicio de sesión fallido, manejar errores
      print('Error en el inicio de sesión');
    }
  }

  void _goToRegistration() {
    Navigator.of(context as BuildContext).pushReplacement(
      MaterialPageRoute(
        builder: (context) => RegistrationForm(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio de Sesión'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: _NameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextFormField(
              controller: _PasswordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: _login,
              child: Text('Iniciar Sesión'),
            ),
            ElevatedButton(
              onPressed: _goToRegistration,
              child: Text('Registrarse'),
            ),
          ],
        ),
      ),
    );
  }

  inicio() {}
}
