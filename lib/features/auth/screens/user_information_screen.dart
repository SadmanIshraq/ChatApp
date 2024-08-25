import 'package:chatapp/common/utils/utils.dart';
import 'package:chatapp/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserInformationScreen extends ConsumerStatefulWidget {
  static const String routeName='/user_information_screen';
  const UserInformationScreen({super.key});

  @override
  ConsumerState<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends ConsumerState<UserInformationScreen> {
  final TextEditingController nameController = TextEditingController();
  File ? image;
  @override
  void dispose(){
    super.dispose();
    nameController.dispose();
  }
  void selectImage()async{
    image = await pickImageFromGallery(context);
    setState(() {

    });
  }
  void storeUserData()async{
    String name=nameController.text.trim();
    if (name.isNotEmpty) {
      ref.read(authControllerProvider).saveUserDataToFirebase(
          context,
          name,
          image);
    }
  }
  @override
  Widget build(BuildContext context) {
    final size= MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white70,
     body: SafeArea(
       child: Center(
         child: Column(
           children: [
             Stack(
               children: [
                 image==null ?
                 const CircleAvatar(
                   backgroundImage: NetworkImage(
                       'https://www.pikpng.com/pngl/m/80-805068_my-profile-icon-blank-profile-picture-circle-clipart.png'
                   ),
                   radius: 65,
                 ): CircleAvatar(
                   backgroundImage: FileImage(image!,
                   ),
                   radius: 65,
                 ),
                 Positioned(
                   bottom:-10,
                   left:80,
                   child: IconButton(
                       onPressed: selectImage,
                       icon:const Icon( Icons.add_a_photo),
                   ),
                 )
               ],
             ),
             Row(
                 children:[
                   Container(
                     width: size.width*0.85,
                     padding:const EdgeInsets.all(20) ,
                     child: TextField(
                       controller:nameController ,
                       decoration: const InputDecoration(
                         hintText: 'Enter your name',
                       ),
                     ),
                   ),
                   IconButton(onPressed: storeUserData,
                     icon:Icon(Icons.done,),
                   ),
                 ],
             ),
           ],
         ),
       ),
     ),
    );
  }
}
