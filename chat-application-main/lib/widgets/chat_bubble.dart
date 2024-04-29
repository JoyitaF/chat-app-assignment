import 'package:flutter/material.dart';
import 'package:random_avatar/random_avatar.dart';

class ChatBubble extends StatefulWidget {
  final TextStyle? textStyle;
  final String message;
  final bool isOwner;
  final String username;

  const ChatBubble({Key? key, required this.message, required this.isOwner, required this.username, this.textStyle}) : super(key: key);

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}


class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.isOwner ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(
          top: 4,
          bottom: 4,
          right: widget.isOwner ? 0 : 55, 
          left: widget.isOwner ? 55 : 0, 
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!widget.isOwner)
              Padding(
                padding: const EdgeInsets.only(left: 3.0),
                child: RandomAvatar(
                  widget.username,
                  trBackground: false,
                  height: 40,
                  width: 40,
                ),
              ),
            Expanded( 
              child: Container(
                alignment: widget.isOwner ? Alignment.centerRight : Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: widget.isOwner ? Colors.white : Colors.blue,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                padding: const EdgeInsets.all(15),
                child: Text(
                  widget.message,
                  style: TextStyle(
                    color: widget.isOwner ? Colors.black : Colors.white,
                  ),
                ),
              ),
            ),
            if (widget.isOwner)
              Padding(
                padding: const EdgeInsets.only(right: 3.0),
                child: RandomAvatar(
                  widget.username,
                  trBackground: false,
                  height: 40,
                  width: 40,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
