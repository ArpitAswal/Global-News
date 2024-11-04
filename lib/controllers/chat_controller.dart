
import 'package:get/get.dart';
import 'package:global_news/models/chat_response_model.dart';
import 'package:global_news/repository/news_repository.dart';

import '../exceptions/app_exception.dart';
import '../models/chat_model.dart';
import '../utils/app_widgets/message_widgets.dart';

class ChatController extends GetxController{

  RxBool isChatOpen = false.obs;
  RxBool isLoading = false.obs;
  final RxList<Contents> messages = <Contents>[].obs;
  final _repo = NewsRepository();

  void sendPrompt(String text) async{
   try {
     messages.add(Contents(role: "user", parts: [Parts(text: text)]));
     isLoading.value = true;
     ChatResponseModel? response = await _repo.geminiAPI(messages: messages);
     if (response != null && response.candidates != null) {
       final botResponse = response.candidates!.first.content.parts.first.text;
       messages.add(Contents(role: "model", parts: [Parts(text: botResponse)]));
     }
   } on AppException catch (e) {
     MessageWidgets.showSnackBar(e.message.toString());
   } catch (e) {
     MessageWidgets.showSnackBar(e.toString());
   } finally{
     isLoading.value = false;
   }
  }

  void toggleChat() {
      isChatOpen.value = !isChatOpen.value;
  }
}