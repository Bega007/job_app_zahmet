import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jobappfirebase/Admin/admin_buttom_navigation_bar.dart';
import 'package:jobappfirebase/ForgetPassword/forget_password_screen.dart';
import 'package:jobappfirebase/Jobs/jobs_screen.dart';
import 'package:jobappfirebase/Services/global_methods.dart';
import 'package:jobappfirebase/SignupPage/signup_screen.dart';

import '../Services/global_variables.dart';

class LoginScreenAdmin extends StatefulWidget {
  @override
  State<LoginScreenAdmin> createState() => _LoginScreenAdminState();
}

class _LoginScreenAdminState extends State<LoginScreenAdmin>
    with TickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;

  final TextEditingController _emailTextController =
      TextEditingController(text: '');
  final TextEditingController _passTextController =
      TextEditingController(text: '');

  final FocusNode _passFocusNode = FocusNode();
  bool _isLoading = false;
  bool _obscureText = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _loginFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _animationController.dispose();
    _emailTextController.dispose();
    _passTextController.dispose();
    _passFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 20));
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.linear)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((animationStatus) {
            if (animationStatus == AnimationStatus.completed) {
              _animationController.reset();
              _animationController.forward();
            }
          });
    _animationController.forward();
    super.initState();
  }

  void _submitFormOnLoginAdmin() async {
    final isValid = _loginFormKey.currentState!.validate();
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      try {
        await _auth.signInWithEmailAndPassword(
          email: _emailTextController.text.trim().toLowerCase(),
          password: _passTextController.text.trim(),
        );
        Navigator.canPop(context) ? Navigator.pop(context) : null;
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        GlobalMethod.showErrorDialog(error: error.toString(), ctx: context);
        print('gynansakda yalnyşlyk yüze çykdy $error');
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  void route() {
    User? admin = FirebaseAuth.instance.currentUser;
    var kk = FirebaseFirestore.instance
        .collection('admin')
        .doc()
        .get()
        .then((DocumentSnapshot collectionSnapshot) {
      if (collectionSnapshot.exists) {
        if (collectionSnapshot.get('admin') == "Admin") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AdminButtomNavigationBar(
                indexNum: 0,
              ),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => JobScreen(),
            ),
          );
        }
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: loginUrlImage,
            placeholder: (context, url) => Image.asset(
              'assets/images/wallpaper.jpg',
              fit: BoxFit.fill,
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            alignment: FractionalOffset(_animation.value, 0),
          ),
          Container(
            color: Colors.black54,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 80),
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 80, right: 80),
                    child: Image.asset('assets/images/login.png'),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Form(
                    key: _loginFormKey,
                    child: Column(
                      children: [
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_passFocusNode),
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailTextController,
                          validator: (value) {
                            if (value!.isEmpty || !value.contains('@')) {
                              return 'Geçerli e-poçta girizin.';
                            } else {
                              return null;
                            }
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: 'E-poçtanyz',
                            hintStyle: TextStyle(color: Colors.white),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          focusNode: _passFocusNode,
                          keyboardType: TextInputType.visiblePassword,
                          controller: _passTextController,
                          obscureText: !_obscureText, //change it dynamically
                          validator: (value) {
                            if (value!.isEmpty || value.length < 7) {
                              return 'Geçerli açar sözünizi girizin';
                            } else {
                              return null;
                            }
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              child: Icon(
                                _obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white,
                              ),
                            ),
                            hintText: 'Açar sözüniz',
                            hintStyle: const TextStyle(color: Colors.white),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            errorBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ForgetPassword()));
                            },
                            child: const Text(
                              'Açar sözünizi yatdan çykardynyzmy?',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        MaterialButton(
                          onPressed: _submitFormOnLoginAdmin,
                          color: Colors.cyan,
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'Ulgama gir',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Center(
                          child: RichText(
                            text: TextSpan(children: [
                              const TextSpan(
                                text: 'Agza bolmak üçin:',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const TextSpan(text: '    '),
                              TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    _showDialog();
                                  },
                                //=> Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp())),
                                text: 'Agza Bol',
                                style: const TextStyle(
                                  color: Colors.cyan,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.grey,
            title: Text('Bildiriş'),
            content: Text(
              'Agza bolup teswirlerinizi goyjak bolsanyz: Şu öyjükli belga: +993 63 46 22 99\'a 5 manat geçirim etseniz size in yakyn wagtda sms arkaly ulanyjy açarynyz ugradylar.Hyzmatymyzy ulanynyz üçin sag bolun.',
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Bolya'),
              ),
            ],
          );
        });
  }
}
