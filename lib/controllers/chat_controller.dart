import 'package:get/get.dart';
import 'package:global_news/models/chat_response_model.dart';
import 'package:global_news/repository/news_repository.dart';

import '../exceptions/app_exception.dart';
import '../models/chat_model.dart';
import '../utils/app_widgets/alert_notify_widgets.dart';

class ChatController extends GetxController {
  final RxBool isChatOpen = false.obs;
  final RxBool hideChat = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool homeChatNavigate = false.obs;
  final RxList<Contents> messages = <Contents>[].obs;

  late NewsRepository _repository;

  @override
  void onInit() {
    super.onInit();
    _repository = Get.find<NewsRepository>(); // Get initialized instance
  }

  void toggleChat() {
    isChatOpen.value = !isChatOpen.value;
  }

  void hideChatScreen() {
    if (isChatOpen.value) {
      hideChat.value = true;
      toggleChat();
    } else {
      hideChat.value = false;
    }
  }

  void sendPrompt(String text) async {
    try {
      messages.add(Contents(role: "user", parts: [Parts(text: text)]));
      isLoading.value = true;
      ChatResponseModel? response =
          await _repository.geminiAPI(messages: messages);
      if (response != null && response.candidates != null) {
        final botResponse = response.candidates!.first.content.parts.first.text;
        messages
            .add(Contents(role: "model", parts: [Parts(text: botResponse)]));
      }
    } on AppException catch (e) {
      AlertNotifyWidgets().showSnackBar(e.message.toString());
    } catch (e) {
      AlertNotifyWidgets().showSnackBar(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
