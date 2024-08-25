import 'package:chatapp/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OTPScreen extends ConsumerWidget {
  static const String routeName= '/otp_screen';
  final String verificationId;
  const OTPScreen({super.key,
    required this.verificationId});
 void verifyOTP(WidgetRef ref, BuildContext context,String userOTP){
    ref.read(authControllerProvider).verifyOTP(
      context,
      verificationId,
      userOTP,
    );
 }

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        title: const Text('Verifying your number',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 22,
          ),
        ),
        elevation: 50,
        backgroundColor: CupertinoColors.activeBlue,

      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50,),
            const Text('We have sent an SMS with a code',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(
              width: size.width*0.51,
              child: TextField(
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  hintText: '- - - - - - ',
                      hintStyle:TextStyle(
                        fontSize: 50,
                      ),
                ),
                keyboardType: TextInputType.number,
                onChanged: (val){
                  if(val.length==6){
                    verifyOTP(ref, context, val.trim());
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
