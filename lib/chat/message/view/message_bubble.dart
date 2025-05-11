import 'package:calm_gut/chat/message/view/bubble_clips.dart';
import 'package:calm_gut/core/widgets/shimmer.dart';
import 'package:calm_gut/repository/message_repository/message_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum MessageAlignment {
  left,
  right;

  bool get isRight {
    return this == MessageAlignment.right;
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    this.prevDifferent = true,
    this.nextDifferent = true,
    this.messageAlignment = MessageAlignment.right,
    this.waitingResponse = false,
  });

  final Message message;
  final bool nextDifferent;
  final bool prevDifferent;
  final MessageAlignment messageAlignment;
  final bool waitingResponse;

  @override
  Widget build(BuildContext context) {
    return _Bubble(
      withTail: nextDifferent,
      message: message,
      onRight: messageAlignment.isRight,
      prevDifferent: prevDifferent,
      waitingResponse: waitingResponse,
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({
    required this.withTail,
    required this.message,
    this.onRight = true,
    this.prevDifferent = false,
    this.waitingResponse = false,
  });

  final bool withTail;
  final Message message;
  final bool onRight;
  final bool prevDifferent;
  final bool waitingResponse;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: _getBubbleMargins(),
      alignment: onRight ? Alignment.topRight : Alignment.topLeft,
      child: ShimmerLoading(
        isLoading: waitingResponse,
        child: PhysicalShape(
          clipper: ChatBubbleClipWithTail(
            leftRadius: onRight ? 20 : 5,
            rightRadius: onRight ? 5 : 20,
            tailRadiusAndOffset: 5,
            tailOnRight: onRight,
            showTail: withTail,
            upperRightRadius: onRight && prevDifferent ? 20 : null,
            upperLeftRadius: !onRight && prevDifferent ? 20 : null,
          ),
          elevation: 1,
          color:
              onRight
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Theme.of(context).colorScheme.tertiaryContainer,
          child: Padding(
            padding:
                onRight
                    ? EdgeInsets.fromLTRB(15, 10, 20, 15)
                    : EdgeInsets.fromLTRB(20, 10, 35, 15),
            child: SizedBox(
              child: Stack(
                children: [
                  RichText(
                    text: TextSpan(
                      text: message.text,
                      style: DefaultTextStyle.of(context).style,
                      children: [
                        TextSpan(
                          text: ' ${message.createdAt.time()}',
                          style: TextStyle(
                            color: Colors.transparent,
                            fontSize: 7,
                            letterSpacing: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: -4,
                    right: 0,
                    child: Text(
                      message.createdAt.time(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  EdgeInsets _getBubbleMargins() {
    if (withTail) {
      return onRight
          ? EdgeInsets.fromLTRB(40, 0, 5, 10)
          : EdgeInsets.fromLTRB(10, 0, 40, 10);
    }
    return onRight
        ? EdgeInsets.fromLTRB(40, 0, 5, 3)
        : EdgeInsets.fromLTRB(10, 0, 40, 3);
  }
}

extension on Timestamp {
  String time() {
    final date = toDate();
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
