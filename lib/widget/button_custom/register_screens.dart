import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'user.dart';
import 'button_custom.dart'; // Asegúrate de importar el archivo correcto

final _formKey = GlobalKey<FormState>();

final _nameController = TextEditingController();
final _emailController = TextEditingController();
final _passwordController = TextEditingController();
final _usernameController = TextEditingController();

void _submit(BuildContext context) {
  try {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text;
      final email = _emailController.text;
      final password = _passwordController.text;
      final username = _usernameController.text;

      // Create a new user
      final user = User(
        name: name,
        email: email,
        password: password,
        username: username,
      );

      // Convert user data to JSON
      final userData = user.toJson();

      // Write the JSON data to a file
      final file = File('usuario.json');
      file.writeAsStringSync(userData);

      // Verificar si la información se guardó correctamente
      final savedData = File('usuario.json').readAsStringSync();
      print('Información guardada en el archivo:\n$savedData');

      // Mostrar mensaje en la consola
      print('Usuario registrado: $username');

      // Navigate to the next screen
      Navigator.pushNamed(context, '/login');
    }
  } catch (error) {
    // Handle the error, puedes imprimirlo o mostrar un diálogo
    print('Error al escribir en el archivo: $error');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Hubo un error al guardar la información.'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class Register extends StatelessWidget {
  const Register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(09.0),
            child: const Text('test'),
          ),
          Center(
            child: Container(
              color: Color.fromARGB(210, 245, 247, 249),
              height: 600,
              width: 350,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Registrar cuenta',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    SizedBox(height: 20),
                    // Cada campo se coloca en un contenedor independiente
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Nombre completo',
                          labelStyle: TextStyle(
                            color: const Color.fromARGB(62, 0, 0, 0),
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                          ),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Correo electrónico',
                          labelStyle: TextStyle(
                            color: const Color.fromARGB(62, 0, 0, 0),
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                          ),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          labelStyle: TextStyle(
                            color: const Color.fromARGB(62, 0, 0, 0),
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                          ),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Nombre de usuario',
                          labelStyle: TextStyle(
                            color: const Color.fromARGB(62, 0, 0, 0),
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                          ),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    // Botón de crear cuenta
                    const ButtonCustom(name: 'register', router: '/mapa'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
