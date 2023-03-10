import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:term_project/widgets/firebase_services.dart';
import '../services/notification_service.dart';
import 'onBoarding.dart';

class SignInPage extends StatefulWidget {
  static const routeName = '/signin-page';

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _obscureText = true;
  String _password = "";
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  Future signUp() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());
    } catch (e) {
      print(e);
      showDialog(
          context: this.context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.toString()),
            );
          });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(color: Color.fromRGBO(53, 83, 88, 1)),
          padding: const EdgeInsets.all(50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Icon(
                    Icons.person,
                    size: 70,
                    color: Colors.white,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30.0),
                    child: Text('Sign Up',
                        style: GoogleFonts.bebasNeue(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 70,
                          ),
                        )),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
                child: TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person_add_alt),
                    border: InputBorder.none,
                    hintText: 'Name & Surname',
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
                child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => EmailValidator.validate(value!)
                        ? null
                        : "Please enter a valid email",
                    controller: _emailController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.email_outlined),
                      border: InputBorder.none,
                      hintText: 'E-Mail',
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white),
                      child: TextFormField(
                        key: _formkey,
                        validator: (value) =>
                            value!.length < 6 ? "Password too short" : null,
                        onSaved: (value) => _password = value.toString(),
                        obscureText: _obscureText,
                        controller: _passwordController,
                        decoration: InputDecoration(
                          errorStyle: const TextStyle(color: Colors.red),
                          suffixIcon: IconButton(
                              onPressed: () {
                                _toggle();
                              },
                              icon: Icon(
                                !_obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              )),
                          icon: const Icon(Icons.lock_outline),
                          border: InputBorder.none,
                          hintText: 'Password',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: const Color.fromARGB(255, 255, 205, 55)),
                        child: TextButton(
                          onPressed: () async {
                            await signUp();
                            await FirebaseAuth.instance.currentUser!
                                .updateDisplayName(_nameController.text);
                            await FirebaseAuth.instance.currentUser!.updatePhotoURL(
                                "https://cdn-icons-png.flaticon.com/512/1246/1246351.png?w=740&t=st=1672479330~exp=1672479930~hmac=908ef0484340b86d3210550a1215c7752d1c289e66f1b68a29e2961c6260b982");
                            Navigator.of(context)
                                .pushNamed(OnBoarding.routeName);
                          },
                          child: Text('Sign up',
                              style: GoogleFonts.ubuntu(
                                textStyle: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: Colors.white),
                        child: TextButton(
                          onPressed: () async {
                            await FirebaseServices().signInWithGoogle();
                            Navigator.of(context).pushNamed('/onBoarding-page');
                          },
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/images/google_logo.png",
                                height: 30,
                                width: 30,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text('Sign up',
                                  style: GoogleFonts.ubuntu(
                                    textStyle: const TextStyle(
                                        fontSize: 20,
                                        color: Color.fromARGB(255, 188, 75, 81),
                                        fontWeight: FontWeight.bold),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Text(
                    "Already account?",
                    style:
                        GoogleFonts.ubuntu(color: Colors.white, fontSize: 15),
                  ),
                  InkWell(
                    onTap: (() {
                      Navigator.pop(context);
                    }),
                    child: Text(
                      " LOG IN",
                      style: GoogleFonts.ubuntu(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
