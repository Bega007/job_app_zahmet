import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobappfirebase/Jobs/jobs_screen.dart';
import 'package:jobappfirebase/Jobs/upload_job.dart';
import 'package:jobappfirebase/Search/profile_company.dart';
import 'package:jobappfirebase/Search/search_companies.dart';
import 'package:jobappfirebase/welcome_page.dart';

class BottomNavigationBarForApp extends StatelessWidget {

  int indexNum = 0;

  BottomNavigationBarForApp({required this.indexNum});

  void _logout(context)
  {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    showDialog(
      context: context,
      builder: (context)
      {
        return AlertDialog(
          backgroundColor: Colors.black54,
          title: Row(
            children: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.logout,
                  color: Colors.white,
                  size: 36,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Sign Out',
                  style: TextStyle(color: Colors.white, fontSize: 28),
                ),
              ),
            ],
          ),
          content: const Text(
            'Do you want to Log Out?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              },
              child: const Text('No', style: TextStyle(color: Colors.green, fontSize: 18),),
            ),
            TextButton(
              onPressed: (){
                _auth.signOut();
                Navigator.canPop(context) ? Navigator.pop(context) : null;
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => welcomePage()));
              },
              child: const Text('Yes', style: TextStyle(color: Colors.green, fontSize: 18),),
            ),
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      backgroundColor: Colors.transparent,
      buttonBackgroundColor: Colors.green.shade400,
      color: Colors.green.shade400,
      height: 60,
      index: indexNum,
      items: const [
        Icon(Icons.list, size: 22, color: Colors.amber,),
        Icon(Icons.bookmark_added_sharp, size: 22, color: Colors.amber,),
        Icon(Icons.chat_sharp, size: 22, color: Colors.amber,),
        //Icon(Icons.add, size: 19, color: Colors.amber,),
        Icon(Icons.person_pin, size: 22, color: Colors.amber,),
        //Icon(Icons.exit_to_app, size: 19, color: Colors.amber,),
      ],
      animationDuration: const Duration(
        milliseconds: 300,
      ),
      //animationCurve: Curves.bounceOut,
      onTap: (index)
      {
        if(index == 0)
          {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => JobScreen()));
          }
        else if(index == 1)
        {
           Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AllWorkersScreen()));
        }
        else if (index == 2)
        {
          
        } 
        /*else if(index == 2)
        {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => UploadJobNow()));
        }*/
        else if(index == 3)
        {
          final FirebaseAuth _auth = FirebaseAuth.instance;
          final User? user = _auth.currentUser;
          final String uid = user!.uid;
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ProfileScreen(
            userID: uid,
          )));
        }
        /*else if(index == 4)
        {
          _logout(context);
        }*/
      },
    );
  }
}
