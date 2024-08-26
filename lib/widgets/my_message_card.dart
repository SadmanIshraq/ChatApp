import 'package:flutter/material.dart';
import 'package:chatapp/colors.dart';

class MyMessageCard extends StatelessWidget {
  final String message;


  const MyMessageCard({Key? key, required this.message, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: Colors.cyan[800],
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 13,
                  right: 17,
                  top: 10,
                  bottom: 13,
                ),
                child: Text(
                  message,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white
                  ),
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}
