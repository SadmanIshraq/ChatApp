import 'package:chatapp/features/chat/controller/chat_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String recieverUserId;
  const BottomChatField({
    required this.recieverUserId,
    super.key,
  });

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}
class _BottomChatFieldState extends ConsumerState<BottomChatField>{
  bool isShowSendButton=false;
  final TextEditingController _messageController = TextEditingController();
  void sendTextMessage()async{
    if(isShowSendButton){
      ref.read(
          chatControllerProvider)
          .sendTextMessage(
          context,
          _messageController.text.trim(),
          widget.recieverUserId);

      setState(() {
        _messageController.text='';
      });
    }
  }

  @override
  void dispose(){
    super.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
          onChanged: (val){
            if(val.isNotEmpty){
              setState(() {
                isShowSendButton=true;
              });
            }else{
              setState(() {
                isShowSendButton=false;
              });
            }
          },
            controller:_messageController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[400],
              hintText: 'Type a message!',

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(
                  width: 0,
                  style: BorderStyle.solid,
                ),
              ),
              contentPadding: const EdgeInsets.all(13),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            bottom: 3,
            right: 7,
            left: 2,
          ),
          child: CircleAvatar(
            backgroundColor: Colors.blueAccent,
            child: GestureDetector(
                child: Icon(
                    isShowSendButton ? Icons.send : Icons.send),
              onTap: sendTextMessage,
            ),
          ),
        )
      ],
    );
  }
}