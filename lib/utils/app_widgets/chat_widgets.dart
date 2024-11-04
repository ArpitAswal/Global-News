import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../controllers/chat_controller.dart';
import 'chat_bubbles.dart';

class ChatWidgets {
  static Widget chatBox(
      Animation<Offset> offsetAnimation, TextEditingController prompt) {
    final chatCtrl = Get.find<ChatController>();

    return SlideTransition(
      position: offsetAnimation,
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          width: Get.width * 0.85,
          height: double.infinity,
          margin: EdgeInsets.only(top: 30.0),
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14.0),
                  bottomLeft: Radius.circular(14.0))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Obx(
                  () => (chatCtrl.messages.isEmpty)
                      ? Text(
                          "What can I help with?",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Obx(() {
                                return ListView.builder(
                                    itemCount: chatCtrl.messages.length +
                                        (chatCtrl.isLoading.value ? 1 : 0),
                                    padding: EdgeInsets.only(top: 10.0),
                                    itemBuilder: (context, index) {
                                      if (index < chatCtrl.messages.length) {
                                        final message =
                                            chatCtrl.messages[index];
                                        return Align(
                                            alignment: (message.role == "user")
                                                ? Alignment.centerRight
                                                : Alignment.centerLeft,
                                            child: Padding(
                                                padding:
                                                    (message.role == "user")
                                                        ? EdgeInsets.only(
                                                            left: 12.0,
                                                            bottom: 10.0)
                                                        : EdgeInsets.only(
                                                            right: 12.0,
                                                            bottom: 10.0),
                                                child: Row(
                                                  mainAxisAlignment: (message.role == "user")
                                                      ? MainAxisAlignment.end
                                                      : MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    if (message.role == "model") ...[
                                                      CircleAvatar(
                                                        radius: 14,
                                                        backgroundColor: Colors.grey.shade200,
                                                        child: Icon(Icons.electric_bolt_rounded),
                                                      ),
                                                    ],
                                                    Flexible(
                                                      child: ConstrainedBox(
                                                        constraints: BoxConstraints(maxWidth: Get.width * 0.8),
                                                        child: (message.role == "user") ?
                                                            ChatBubbles.userMessage(message.parts.first.text) :
                                                        ChatBubbles.botMessage(
                                                          message.parts.first.text,
                                                        ),
                                                      ),
                                                    ),
                                                    if (message.role == "user") ...[
                                                      CircleAvatar(
                                                        radius: 16,
                                                        backgroundColor: Colors.deepPurple.shade50,
                                                        child: Icon(
                                                          Icons.person_rounded,
                                                          color: Colors.deepPurple.shade400,
                                                        ),
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                            ));
                                      } else {
                                        // Show loading animation at the end of the list
                                        return Align(
                                            alignment: Alignment.topLeft,
                                            child: LoadingAnimationWidget
                                                .progressiveDots(
                                                    color: Colors.grey.shade400,
                                                    size: 40));
                                      }
                                    });
                              }),
                            ),
                          ],
                        ),
                ),
              ),
              TextFormField(
                controller: prompt,
                cursorColor: Colors.black,
                textInputAction: TextInputAction.send,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14)),
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14)),
                    hintText: "Ask Gemini",
                    hintStyle: TextStyle(
                        color: Colors.black45,
                        fontSize: 18,
                        fontWeight: FontWeight.w400),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 2.0),
                      child: IconButton(
                          onPressed: () {
                            if (prompt.text.isNotEmpty) {
                              chatCtrl.sendPrompt(prompt.text);
                            }
                            prompt.clear();
                          },
                          icon: Icon(
                            Icons.arrow_upward_rounded,
                            color: Colors.white,
                          ),
                          tooltip: "Send Prompt",
                          style: IconButton.styleFrom(
                              shape: CircleBorder(),
                              backgroundColor: Colors.black)),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  static Widget chatButton({required Function()? pressed}) {
    return Align(
      alignment: Alignment.bottomRight,
      child: IconButton(
        onPressed: pressed,
        tooltip: "Ask Gemini",
        style: IconButton.styleFrom(
            shape: CircleBorder(), backgroundColor: Colors.deepPurple.shade50),
        icon: Icon(Icons.online_prediction_rounded),
      ),
    );
  }
}
