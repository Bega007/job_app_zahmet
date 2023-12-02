import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobappfirebase/Admin/admin_buttom_navigation_bar.dart';
import 'package:jobappfirebase/Jobs/jobs_screen.dart';
import 'package:jobappfirebase/LoginPage/login_screen.dart';
import 'package:jobappfirebase/LoginPage/login_screen_admin.dart';

class welcomePage extends StatelessWidget {
  const welcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (ctx, userSnapshot) {
        if (userSnapshot.data == null) {
          print('user is not logged in yet');
          return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Card(
              elevation: 12,
              margin: EdgeInsets.all(10),
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Ink.image(
                    image: AssetImage(
                      'assets/images/wallpaper.jpg',
                    ),
                    height: 250,
                    fit: BoxFit.cover,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) => LoginScreenAdmin()));
                      },
                    ),
                  ),
                  Text(
                    'İşgar gerek',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    left: 16,
                    child: Text(
                      'Tölegsiz teswirle,hyzmat al ya-da gözleginde bolan işgarini tap',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Card(
              elevation: 12,
              margin: EdgeInsets.all(10),
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Ink.image(
                        image: AssetImage(
                          'assets/images/wallpaper.jpg',
                        ),
                        height: 250,
                        fit: BoxFit.cover,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        Login()));
                          },
                        ),
                      ),
                      Text(
                        'İş gerek',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        right: 16,
                        left: 16,
                        child: Text(
                          'Uzyn wagtly,gysga wagtlayyn ya-da hyzmatyny ber',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ]);
        } 
        else if (userSnapshot.hasData) {
          print('user is already logged in yet');
          User? user = FirebaseAuth.instance.currentUser;
    var kk = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (documentSnapshot.get('rool') == "Admin") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => JobScreen(
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
         else if (userSnapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text('Nasazlyk yuze çykdy. Tazeden barlan'),
            ),
          );
        } else if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return const Scaffold(
          body: Center(
            child: Text('way bir yerlerde yalnyshlyk bar'),
          ),
        );
      },
    );
  }

}
