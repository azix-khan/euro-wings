import 'package:euro_wings/views/custom_widgets/widgets/round_button.dart';
import 'package:euro_wings/views/custom_widgets/widgets/utils/utils.dart';
import 'package:euro_wings/views/screens/AdminPanel/items_screen.dart';
import 'package:euro_wings/views/screens/auth/forgot_password_screen.dart';
import 'package:euro_wings/views/screens/auth/signup_screen.dart';
import 'package:euro_wings/views/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool loading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void login() async {
    setState(() {
      loading = true;
    });

    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text.toString(),
      );

      // ignore: unnecessary_null_comparison
      if (userCredential != null) {
        setState(() {
          loading = false;
        });

        Utils().toastMessage("Login Successfully");
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AdminHomeScreen()),
        );
      }
    } catch (error) {
      debugPrint(error.toString());
      setState(() {
        loading = false;
      });
      Utils().toastMessage(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Admin Login',
          ),
          leading: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeScreen()));
              },
              child: const Icon(
                Icons.arrow_back_ios_new,
              )),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 250,
                    child: Image.asset('images/login.png'),
                  ),
                  TextFormField(
                    controller: emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Email Required';
                      }
                      String pattern =
                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                      RegExp regex = RegExp(pattern);
                      if (!(regex.hasMatch(value))) {
                        return 'Invalid Email';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Email',
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Password Required';
                      }
                      String pattern =
                          r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)";
                      RegExp regex = RegExp(pattern);
                      if (!(regex.hasMatch(value))) {
                        return 'Use special characters and numbers';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Password',
                      prefixIcon: const Icon(Icons.lock_open),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  RoundButton(
                    loading: loading,
                    title: 'Login',
                    onTap: () {
                      if (_formkey.currentState!.validate()) {
                        login();
                      }
                    },
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ForgotPasswordScreen()));
                      },
                      child: const Text("Forgot Password"),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpScreen(),
                            ),
                          );
                        },
                        child: const Text("Sign Up"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
