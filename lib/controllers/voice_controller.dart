import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';

class VoiceController extends GetxController {
  final FlutterTts flutterTts = FlutterTts();
  RxBool ttsState = false.obs; // Indicates if the voice is playing
  List<String> messageQueue = []; // Queue of messages to read sequentially
  bool isStopped = false; // Flag to check if the TTS should stop

  @override
  void onInit() {
    ttsSetUp();
    super.onInit();
  }

  @override
  void onClose() {
    stop(); // Ensures TTS stops when controller is disposed
    super.onClose();
  }

  void ttsSetUp() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    flutterTts.setCompletionHandler(_onSpeakCompleted); // Completion handler
  }

  Future speak({required String firstMsg, required String secondMsg, required String thirdMsg}) async {
    isStopped = false; // Reset stop flag
    ttsState.value = true;
    messageQueue = [firstMsg, secondMsg, thirdMsg]; // Add messages to queue
    await _speakNextMessage(); // Start speaking
  }

  Future _speakNextMessage() async {
    if (messageQueue.isNotEmpty && !isStopped) {
      String message = messageQueue.removeAt(0); // Get the next message
      await flutterTts.speak(message);
    } else {
      await stop(); // Stop if queue is empty or stop was called
    }
  }

  Future stop() async {
    isStopped = true; // Set flag to prevent further speaking
    ttsState.value = false;
    await flutterTts.stop();
  }

  void _onSpeakCompleted() {
    if (!isStopped) {
      _speakNextMessage(); // Speak the next message if not stopped
    }
  }
}
