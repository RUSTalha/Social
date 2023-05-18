import'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'main.dart';

class SignUpPage extends StatefulWidget {
@override
_SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
// Define a TextEditingController to get the user email
final emailController = TextEditingController();

// Define a TextEditingController to get the user password
final passwordController = TextEditingController();

// Define a FirebaseAuth variable to handle authentication
final auth = FirebaseAuth.instance;

// Define a method to sign up with email and password
signUp(String email, String password) async {
try {
// Sign up with email and password and get the user credential
final userCredential = await auth.createUserWithEmailAndPassword(
email: email,
password: password,
);
// Navigate to the home page if sign up is successful
Navigator.push(
context,
MaterialPageRoute(
builder: (context) => HomePage(userCredential.user),
),
);
} on FirebaseAuthException catch (e) {
// Handle the error if sign up fails
if (e.code == 'weak-password') {
print('The password provided is too weak.');
} else if (e.code == 'email-already-in-use') {
print('The account already exists for that email.');
}
}
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: Text('Social Media App'),
),
body: Center(
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
// A text field to enter the user email
TextField(
controller: emailController,
decoration: InputDecoration(
hintText: 'Enter your email',
border: OutlineInputBorder(),
),
),
// A text field to enter the user password
TextField(
controller: passwordController,
obscureText: true,
decoration: InputDecoration(
hintText: 'Enter your password',
border: OutlineInputBorder(),
),
),
// A button to sign up with email and password
ElevatedButton(
onPressed: () {
signUp(emailController.text, passwordController.text);
},
child: Text('Sign Up'),
),
// A button to navigate to the sign in page if the user already has an account
TextButton(
onPressed: () {
Navigator.pop(context);
},
child: Text('Already have an account? Sign in'),
),
],
),
),
);
}
}