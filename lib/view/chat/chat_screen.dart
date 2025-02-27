import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../controllers/chat_controller.dart';
import '../../utils/app_widgets/chat_bubbles.dart';

class BuildScreenAndChat extends StatefulWidget {
  const BuildScreenAndChat({super.key, required this.mainContent});

  final Widget mainContent;

  @override
  State<BuildScreenAndChat> createState() => _BuildScreenAndChatState();
}

class _BuildScreenAndChatState extends State<BuildScreenAndChat>
    with SingleTickerProviderStateMixin {
  final ChatController chatCtrl = Get.find();
  final _prompt = TextEditingController();

  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(1.0, 1.0),
      end: const Offset(0.0, 0.0),
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.reverse();
    _animationController.dispose();
    _prompt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        widget.mainContent, // Display the main content
        IconButton(
          onPressed: () {
            chatCtrl.toggleChat();
            chatCtrl.isChatOpen.value
                ? _animationController.forward()
                : _animationController.reverse();
          },
          tooltip: "Ask Gemini",
          style: IconButton.styleFrom(
              shape: const CircleBorder(),
              backgroundColor: Colors.deepPurple.shade400,
              foregroundColor: Colors.white),
          icon: const Icon(Icons.online_prediction_rounded),
        ),
        Obx(() {
          if (chatCtrl.hideChat.value) {
            _animationController.reverse();
          }
          return GestureDetector(
            onHorizontalDragEnd: (DragEndDetails details) {
              if (details.primaryVelocity! > 0) {
                chatCtrl.toggleChat();
                chatCtrl.isChatOpen.value
                    ? _animationController.forward()
                    : _animationController.reverse();
              }
            },
            child: SlideTransition(
              position: _offsetAnimation,
              child: _chatContainer(),
            ),
          );
        }),
      ],
    );
  }

  Widget _chatContainer() {
    return Container(
      width: Get.width * 0.85,
      height: Get.height, // Adjust height as needed
      margin: const EdgeInsets.only(top: 30.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(14.0),
              bottomLeft: Radius.circular(14.0))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Obx(
              () => (chatCtrl.messages.isEmpty)
                  ? const Center(
                      child: Text(
                        "What can I help with?",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: chatCtrl.messages.length +
                          (chatCtrl.isLoading.value ? 1 : 0),
                      padding: const EdgeInsets.only(top: 10.0),
                      itemBuilder: (context, index) {
                        if (index < chatCtrl.messages.length) {
                          final message = chatCtrl.messages[index];
                          return Align(
                            alignment: (message.role == "user")
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: message.role == "user" ? 12.0 : 0,
                                  right: message.role == "user" ? 0 : 12.0,
                                  bottom: 10.0),
                              child: Row(
                                mainAxisAlignment: (message.role == "user")
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (message.role == "model")
                                    const CircleAvatar(
                                      radius: 14,
                                      backgroundColor: Colors.grey,
                                      child: Icon(Icons.electric_bolt_rounded),
                                    ),
                                  Flexible(
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                          maxWidth: Get.width * 0.8),
                                      child: (message.role == "user")
                                          ? ChatBubbles.userMessage(
                                              message.parts.first.text)
                                          : ChatBubbles.botMessage(
                                              message.parts.first.text,
                                            ),
                                    ),
                                  ),
                                  if (message.role == "user")
                                    CircleAvatar(
                                      radius: 16,
                                      backgroundColor:
                                          Colors.deepPurple.shade50,
                                      child: Icon(
                                        Icons.person_rounded,
                                        color: Colors.deepPurple.shade400,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return Align(
                            alignment: Alignment.topLeft,
                            child: LoadingAnimationWidget.progressiveDots(
                                color: Colors.grey.shade400, size: 40),
                          );
                        }
                      },
                    ),
            ),
          ),
          TextFormField(
            controller: _prompt,
            cursorColor: Colors.black,
            textInputAction: TextInputAction.send,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
              filled: true,
              fillColor: Colors.grey.shade200,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              enabledBorder:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              focusedBorder:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              disabledBorder:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              hintText: "Ask Gemini",
              hintStyle: const TextStyle(
                  color: Colors.black45,
                  fontSize: 18,
                  fontWeight: FontWeight.w400),
              suffixIcon: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                child: IconButton(
                  onPressed: () {
                    if (_prompt.text.isNotEmpty) {
                      chatCtrl.sendPrompt(_prompt.text);
                    }
                    _prompt.clear();
                  },
                  icon: const Icon(
                    Icons.arrow_upward_rounded,
                    color: Colors.white,
                  ),
                  tooltip: "Send Prompt",
                  style: IconButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
