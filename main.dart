import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
// Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignInPage(),
    );
  }
}

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
// Define a TextEditingController to get the user email
  final emailController = TextEditingController();

// Define a TextEditingController to get the user password
  final passwordController = TextEditingController();

// Define a FirebaseAuth variable to handle authentication
  final auth = FirebaseAuth.instance;

// Define a method to sign in with email and password
  signIn(String email, String password) async {
    try {
// Sign in with email and password and get the user credential
      final userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
// Navigate to the home page if sign in is successful
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(userCredential.user),
        ),
      );
    } on FirebaseAuthException catch (e) {
// Handle the error if sign in fails
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
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
// A button to sign in with email and password
            ElevatedButton(
              onPressed: () {
                signIn(emailController.text, passwordController.text);
              },
              child: Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
// Define a User variable to store the current user
  final User user;

// Define a constructor that takes the user as an argument
  HomePage(this.user);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
// Define a TextEditingController to get the message input
  final messageController = TextEditingController();

// Define a FirebaseFirestore variable to handle database operations
  final firestore = FirebaseFirestore.instance;

// Define a method to send a message to the database
  sendMessage(String message) async {
    try {
// Add a document to the messages collection with the message and the user id
      await firestore.collection('messages').add({
        'message': message,
        'userId': widget.user.uid,
      });
// Clear the text field after sending the message
      messageController.clear();
    } catch (e) {
// Handle the error if sending fails
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('Social Media App'),
    actions: [
// A button to sign out from the app
    IconButton(
    icon: Icon(Icons.logout),
    onPressed: () async {
// Sign out from Firebase Auth and navigate back to the sign in page
    await FirebaseAuth.instance.signOut();
    Navigator.pop(context);
    },
    ),
    ],
    ),
    body: Column(
    children: [
// A flexible widget to display the list of messages from the database
    Flexible(
    child: StreamBuilder<QuerySnapshot>(
    stream: firestore.collection('messages').snapshots(),
    builder: (context, snapshot) {
    if (snapshot.hasData) {
// Get the list of documents from the snapshot data
      final documents =
    }
    }
    )
    )
    ]
    )
    );
  }
}