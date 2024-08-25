import 'package:chatapp/common/utils/utils.dart';
import 'package:chatapp/common/widgets/custom_button.dart';
import 'package:chatapp/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class LoginScreen extends ConsumerStatefulWidget {
  static const String routeName='/login_screen';
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final phoneController = TextEditingController();
  Country?country;
  @override
  void dispose(){
    super.dispose();
    phoneController.dispose();
  }
  void pickCountry(){
    showCountryPicker(context: context,
        onSelect: (Country _country){
      setState(() {
        country= _country;
      });
    });
  }
  void sendPhoneNumber(){
    String phoneNumber= phoneController.text.trim();
    if(country!=null && phoneNumber.isNotEmpty){
      ref.
      read(authControllerProvider).
      signInWithPhone(context, '+${country!.phoneCode}$phoneNumber');
    }else{
     showSnackBar(context: context, content: 'Fill out all the fields');
    }
  }
  @override
  Widget build(BuildContext context) {
    final size= MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        title: const Text('Enter your phone number',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 22,
        ),
        ),
        elevation: 50,
        backgroundColor: CupertinoColors.activeBlue,

      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 25,),
              const Text('Chatify will need to varify your phone number.'),
              const SizedBox(height: 50,),
              TextButton(onPressed: pickCountry,
                child: Text('Pick Country'),
              ),
                const SizedBox(height: 10,),
              Row(
                children: [
                  if (country!=null)
                  Text('+${country!.phoneCode}'),
                  const SizedBox(width: 15,),
                  SizedBox(
                    width:size.width * .7,
                    child: TextField(
                      controller:phoneController,
                      decoration: const InputDecoration(
                        hintText: 'phone number'
                      ),
                    ),
        
                  ),
        
                ],
              ),
              SizedBox(height: 200),
              SizedBox(
              width: 150,
                child: CustomButton(
                  onPressed: sendPhoneNumber,
                  text: 'NEXT',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
