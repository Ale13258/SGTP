import 'package:flutter/material.dart';
import 'package:register/config/app_router.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}

// class RegistrationForm extends StatefulWidget {
//   const RegistrationForm({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _RegistrationFormState createState() => _RegistrationFormState();
// }

// class _RegistrationFormState extends State<RegistrationForm> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _usernameController = TextEditingController();
//   final _rollController = TextEditingController();

//   Future<void> _submifrom() async {
//     var logger = Logger();
//     logger.d("holi");
//     // if (_formKey.currentState!.validate()) {
//     try {
//       final response = await http.post(
//         Uri.parse("http://localhost:4000/register"),
//         body: {
//           'name': _nameController.text,
//           'email': _emailController.text,
//           'password': _passwordController.text,
//           'username': _usernameController.text,
//           'roll': _rollController.text,
//         },
//       );

//       if (response.statusCode == 200) {
//         print('Register exitoso');
//         Navigator.of(context as BuildContext).pushReplacement(
//           MaterialPageRoute(
//             builder: (context) => LoginScreen(),
//           ),
//         );
//       } else {
//         print('Error en el registro: ${response.statusCode}');
//         // Puedes agregar un mensaje de error específico según la respuesta del servidor.
//       }
//     } catch (e) {
//       print('Error en la solicitud HTTP: $e');
//       // Puedes manejar el error de manera adecuada, por ejemplo, mostrando un mensaje al usuario.
//     }
//     // }
//   }
// }

