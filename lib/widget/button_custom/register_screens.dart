import 'package:flutter/material.dart';

class Register extends StatelessWidget {
  const Register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController();
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();
    final _usernameController = TextEditingController();
    final _rollController = TextEditingController();

    final backgroundImage = AssetImage('assets/aleja.jpg');

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
                    // ElevatedButton(
                    //   onPressed: _submit,
                    //   child: Text('Crear cuenta'),
                    //   style: ElevatedButton.styleFrom(
                    //     primary: Colors.orange,
                    //   ),
                    // ),
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
