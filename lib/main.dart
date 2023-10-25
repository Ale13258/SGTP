
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:register/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RegistrationForm(),
    );
  }
}

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _rollController = TextEditingController();

Future<void> _submifrom() async {
  var logger = Logger();
  logger.d("holi");
  // if (_formKey.currentState!.validate()) {
    try {
      final response = await http.post(
        Uri.parse("http://localhost:4000/register"),
        body: {
          'name': _nameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
          'username': _usernameController.text,
          'roll': _rollController.text,
        },
      );

      if (response.statusCode == 200) {
        print('Register exitoso');
        Navigator.of(context as BuildContext).pushReplacement(
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
      } else {
        print('Error en el registro: ${response.statusCode}');
        // Puedes agregar un mensaje de error específico según la respuesta del servidor.
      }
    } catch (e) {
      print('Error en la solicitud HTTP: $e');
      // Puedes manejar el error de manera adecuada, por ejemplo, mostrando un mensaje al usuario.
    }
  // }
}



  @override
  Widget build(BuildContext context) => Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(09.0),
            child: Image.network("img/aleja.jpg",
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
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
                      'Registrate',
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
                          labelText: 'name',
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
                          labelText: 'email',
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
                          labelText: 'password',
                          labelStyle: TextStyle(
                            color: Color.fromARGB(62, 0, 0, 0),
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
                          labelText: 'username',
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
                        controller: _rollController,
                        decoration: InputDecoration(
                          labelText: 'roll',
                          labelStyle: TextStyle(
                            color: Color.fromARGB(62, 0, 0, 0),
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                          ),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    // Botón de crear cuenta
                    ElevatedButton(
                      onPressed: _submifrom,
                      child: Text('Crear cuenta'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
}



  
    
  



