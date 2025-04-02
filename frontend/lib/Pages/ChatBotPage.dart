import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:weski/Api/openAIApi.dart';
import 'package:weski/Widget/customMessageDisplay.dart';

import '../Assets/Theme.dart';
import '../Widget/customTriangle.dart';


class ChatBotPage extends StatefulWidget {
  final LocationData cuentLocation;

  const ChatBotPage({super.key, required this.cuentLocation});

  @override
  ChatBotPageState createState() => ChatBotPageState();
}

class ChatBotPageState extends State<ChatBotPage> {
  late String result;
  final ScrollController scrollController = ScrollController();
  final TextEditingController messageController = TextEditingController();
  ValueNotifier<List<Map<String, dynamic>>> messagesNotifier = ValueNotifier<List<Map<String, dynamic>>>([]);
  final OpenAiApi openAiApi = OpenAiApi();
  List<String> quickQuestions = [
    "Care este cea mai apropiata statiune? La cati km?",
    "Pognoza meteo pe 5 zile la cel mai apropiat resort",
    "Care sunt condițiile meteo pentru acest weekend?",
    "Cum aleg un snowboard potrivit?",
    "Cum aleg ski-uri potrivite?",
  ];


  void sendMessageRequestToBot(bool isFromUser) {
    if (messageController.text.trim().isNotEmpty && isFromUser) {
        messagesNotifier.value = [...messagesNotifier.value, {"text":messageController.value.text, "isFromUser":isFromUser}];
        messageController.clear();
    }
  }

  void getMessageResponseFromBot(bool isFromUser, String response){
    if (response.isNotEmpty && (isFromUser == false)) {
      messagesNotifier.value = [...messagesNotifier.value, {"text":response, "isFromUser":isFromUser}];
      messageController.clear();
    }else{
      print("eroare la mesaj");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenDiagonal = sqrt(pow(screenWidth,2)+pow(screenHeight,2));

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Color(theme.colorScheme.primary.value,),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context, false),
        ),
        centerTitle: true,
        title: Text("Chat WeSki", style: TextStyle(fontSize: screenDiagonal * 0.03, fontWeight: FontWeight.bold, color: Colors.white),),

      ),
      body: Stack(
        children: [
          Positioned(
              right: screenWidth * 0.045,
              bottom: screenHeight * 0.14065,
              child: ClipPath(
                clipper: customTriangle(),
                child: Container(
                  color: Color(theme.colorScheme.primary.value),
                  width: screenWidth * 0.35,
                  height: screenHeight * 0.105,
                ),
              )
          ),
          Positioned(
              right: screenWidth * 0.0004,
              bottom: screenHeight * 0.14082,
              child: ClipPath(
                clipper: customTriangle(),
                child: Container(
                  color: Color(theme.colorScheme.primary.value),
                  width: screenWidth * 0.2,
                  height: screenHeight * 0.06,
                ),
              )
          ),
          Positioned(
              right: screenWidth * 0.145,
              bottom: screenHeight * 0.11245,
              child: ClipPath(
                clipper: customTriangle(),
                child: Container(
                  color: Color(theme.colorScheme.primary.value),
                  width: screenWidth * 0.35,
                  height: screenHeight * 0.105,
                ),
              )
          ),
          Positioned(
              right: screenWidth * 0.22,
              bottom: screenHeight * 0.08525,
              child: ClipPath(
                clipper: customTriangle(),
                child: Container(
                  color: Color(theme.colorScheme.primary.value),
                  width: screenWidth * 0.37,
                  height: screenHeight * 0.105,
                ),
              )
          ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: screenHeight * 0.013
                ),),
                Expanded(
                  child: ValueListenableBuilder<List<Map<String, dynamic>>>(
                    valueListenable: messagesNotifier,
                    builder: (context, messages, child) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (scrollController.hasClients) {
                          scrollController.animateTo(
                            scrollController.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                        }
                      });
                      return ListView.builder(
                        controller: scrollController,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          return CustomMessageDisplay(
                            fillColor: theme.brightness == lightTheme.brightness? 0xFFE8E8E8 : 0xFF414245,
                            textColor: 0XFFFFFFFF,
                            textContent: messages[index]["text"],
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                            isFromUser: messages[index]["isFromUser"],
                          );
                        },
                      );
                    },
                  ),
                ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: screenHeight * 0.2
                ),),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: screenHeight*0.15,
              width: screenWidth,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(0),
                  topRight: Radius.circular(14),
                ),
                color: Color(theme.colorScheme.primary.value),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical:screenDiagonal * 0.02,
                    horizontal: screenDiagonal * 0.01
                ),
                child: TextField(
                  controller: messageController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.grey),
                    hintText: "Type here..",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Color(theme.colorScheme.surface.value),
                    contentPadding: EdgeInsets.all(10),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.brightness == lightTheme.brightness? Colors.black12 : Colors.white12,
                          shape: BoxShape.circle
                        ),
                        child: IconButton(
                          icon: Icon(Icons.send, color: Color(theme.colorScheme.primary.value), ),
                          onPressed: () async {
                            result = await openAiApi.responseFromOpenAi("${messageController.value.text} ,locatia curenta: ${widget.cuentLocation}");
                            sendMessageRequestToBot(true);
                            getMessageResponseFromBot(false, result);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: screenDiagonal * 0.00,
              bottom: screenDiagonal * 0.13
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child:GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
                    ),
                    builder: (context) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: quickQuestions.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(quickQuestions[index]),
                            onTap: () async {
                              Navigator.pop(context);
                              messageController.text = quickQuestions[index];
                              result = await openAiApi.responseFromOpenAi("${messageController.value.text},locatia curenta: ${widget.cuentLocation}");
                              sendMessageRequestToBot(true);
                              getMessageResponseFromBot(false, result);
                            },
                          );
                        },
                      );
                    },
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(14),
                      bottomLeft: Radius.circular(0),
                      topRight: Radius.circular(14),
                      bottomRight: Radius.circular(0),
                    ),
                    color: Color(theme.colorScheme.primary.value),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18),
                    child: Text(
                      "Quick Questions",
                      style: TextStyle(color: Colors.white, fontSize: screenDiagonal * 0.017),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}