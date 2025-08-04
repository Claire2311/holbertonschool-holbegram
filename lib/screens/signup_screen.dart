import 'package:flutter/material.dart';
import 'package:holbegram/methods/auth_methods.dart';
import 'package:holbegram/screens/auth/upload_image_screen.dart';
import '../widgets/text_field.dart';
import './login_screen.dart';
import '../screens/upload_image_screen.dart';

class SignUp extends StatefulWidget {
  final TextEditingController? emailController;
  final TextEditingController? usernameController;
  final TextEditingController? passwordController;
  final TextEditingController? passwordConfirmController;
  final bool _passwordVisible = true;

  const SignUp({
    super.key,
    this.emailController,
    this.usernameController,
    this.passwordController,
    this.passwordConfirmController,
  });

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late bool _passwordVisible;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _passwordVisible = widget._passwordVisible;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 100),
            Text(
              'Holbegram',
              style: TextStyle(fontFamily: 'Billabong', fontSize: 50),
            ),
            Image.asset('assets/images/logo.webp', width: 80, height: 60),
            Padding(
              padding: EdgeInsets.all(30),
              child: Text(
                "Sign up to see photos and videos from your friends.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(150, 83, 83, 83),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[
                  TextFieldInput(
                    controller: _emailController,
                    ispassword: false,
                    hintText: 'Email',
                    suffixIcon: Icon(Icons.email),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 24),
                  TextFieldInput(
                    controller: _usernameController,
                    ispassword: false,
                    hintText: 'Full Name',
                    suffixIcon: Icon(Icons.person),
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 24),
                  TextFieldInput(
                    controller: _passwordController,
                    ispassword: !_passwordVisible,
                    hintText: 'Password',
                    suffixIcon: IconButton(
                      alignment: Alignment(-1.0, 1.0), //bottomLeft
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 24),
                  TextFieldInput(
                    controller: _passwordConfirmController,
                    ispassword: !_passwordVisible,
                    hintText: 'Confirm Password',
                    suffixIcon: IconButton(
                      alignment: Alignment(-1.0, 1.0), //bottomLeft
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 48),
                  SizedBox(
                    height: 48,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          Color.fromARGB(218, 226, 37, 24),
                        ),
                      ),
                      onPressed: () async {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddPicture(
                              email: _emailController.text.trim(),
                              password: _passwordController.text.trim(),
                              username: _usernameController.text.trim(),
                            ),
                          ),
                        );
                        // String result = await AuthMethode().signUpUser(
                        //   context: context,
                        //   email: _emailController.text.trim(),
                        //   password: _passwordController.text.trim(),
                        //   username: _usernameController.text.trim(),
                        // );
                      },
                      child: Text(
                        "Sign up",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Divider(thickness: 2),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Log in",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(218, 226, 37, 24),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
