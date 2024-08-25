import 'package:chatapp/common/widgets/custom_button.dart';
import 'package:chatapp/features/auth/screens/login_screen.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  void navigateToLoginScreen(BuildContext context){
    Navigator.pushNamed(context, LoginScreen.routeName);
  }
  @override
  Widget build(BuildContext context) {
    final size= MediaQuery.of(context).size;
    return Scaffold(backgroundColor: Colors.white70,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40,),
            const Text('Welcome to Chatify',
                style:TextStyle(
                  fontSize: 37,
                  fontWeight: FontWeight.w800,
                ),
            ),
            Image.asset('assets/bg.png',
            height: 400,
            width: 400,
            ),
            Padding(padding: EdgeInsets.only(left: 10,right: 10,bottom: 15),
            child:Text('Tap "Agree and continue" to register via phone number',
              style:TextStyle(
              fontSize: 16,
                color:Colors.black ,
            ),
              textAlign: TextAlign.center,
            ),
      ),
            SizedBox(height: 10,),
            SizedBox(
              width:300 ,
              child: CustomButton(text: 'AGREE AND CONTINUE',
                onPressed:() => navigateToLoginScreen(context),
              ),
            )
          ],
        ),

      ),
    );
  }
}
