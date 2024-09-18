import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dor_companion/data/api/sensy_api.dart';
import 'package:dor_companion/data/models/models.dart';
import 'package:dor_companion/injection/injection.dart';
import 'package:dor_companion/widgets/appbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../data/models/search_suggestions.dart';
import '../../utils.dart';
import '../widgets/media_detail/media_row_view.dart';

// Message model to handle message content and alignment
class Message {
  String content;
  bool isSentByMe;
  bool isThinking;

  Message(
      {required this.content,
      this.isSentByMe = false,
      this.isThinking = false});
}

// Item model for the horizontal list
class Item {
  String name;

  Item({required this.name});
}

class GenAISearchView extends StatelessWidget {
  final SensyApi sensyApi;
  final SearchSuggestions searchSuggestion;
  const GenAISearchView({super.key, required this.sensyApi, required this.searchSuggestion,});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: GenAISearchBody(),
    );
  }
}

class GenAISearchBody extends StatefulWidget {
  const GenAISearchBody({super.key,});

  @override
  State createState() => _GenAISearchState();
}

class _GenAISearchState extends State<GenAISearchBody> {
  final List<Message> _messages = [];
   List<MediaRow> _items = [];
  final List<Map<String, String>> _messageHistory = [];
  final TextEditingController _textEditController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();
  final ScrollController _mediaRowScrollController = ScrollController();

  Future<void> fetchData(String itemId, String itemType) async {
    return getIt<SensyApi>().fetchMediaDetail(itemId, itemType).then((value) {
      if (itemType == 'find') {
        _items = value.mediaRows;
      } else {
        _items = value.mediaRows;
      }
    }).catchError((Object errorObj) {
      if (kDebugMode) {
        print("Failed to fetch favorite languages: ${errorObj.toString()}");
      }
      switch (errorObj.runtimeType) {
        case DioException:
          final response = (errorObj as DioException).response;
          showVanillaToast(
              "Failed to fetch favorite languages: ${response?.statusCode}");
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // sendMessage(CustomSearchDelegate.voice,"true");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Row(
        children: [
          // Chat interface takes up 1/3 of the screen
          Expanded(
            flex: 6,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    controller: _chatScrollController,
                    itemCount: _messages.length,
                    reverse: true,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return ListTile(
                        title: Align(
                          alignment: message.isSentByMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 15.0),
                            decoration: BoxDecoration(
                              color: message.isSentByMe
                                  ? Colors.blue
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Stack(
                              children: [
                                if (message.isThinking)
                                  const Positioned(
                                    left:
                                        0, // Adjust based on your layout needs
                                    top: 0, // Adjust for vertical alignment
                                    bottom: 0, // Adjust for vertical alignment
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 8.0),
                                      child: SizedBox(
                                        width:
                                            16, // Reduced size of the CircularProgressIndicator
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Colors
                                                .blue, // Adjust color based on your theme
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                Padding(
                                  padding: message.isThinking
                                      ? const EdgeInsets.only(
                                          left:
                                              28.0) // Adjust the left padding to make space for the progress indicator
                                      : EdgeInsets.zero,
                                  child: Text(
                                    message.content,
                                    style: TextStyle(
                                      color: message.isSentByMe
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            autofocus: true,
                            controller: _textEditController,
                            style: const TextStyle(
                              color: Colors.black, // Changes the text color
                            ),
                            cursorColor: Colors.blue,
                            decoration: const InputDecoration(
                              hintText: "Ask Me Anything ...",
                              hintStyle: TextStyle(
                                color: Colors
                                    .grey, // Changes the hint text color for better visibility
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 15.0),
                            ),
                            onSubmitted: (value) => sendMessage(_textEditController.text,"false"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0), // Small padding for the send button
                          child: IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: ()=>sendMessage(_textEditController.text,"false"),
                            color: Colors
                                .blue, // Change the send icon color for better visibility
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Horizontal list view takes up the remaining 2/3 of the screen
          Expanded(
            flex: 3,
            child: CustomScrollView(
                controller: _mediaRowScrollController,
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => MediaRowView(
                        _items[index],
                      ),
                      childCount: _items.length,
                    ),
                  ),
                ]),
          ),
        ],
      ),
    );
  }

  void sendMessage(String msg,String pos) {
     final textMsg= msg;
    if (textMsg.isNotEmpty) {
      setState(() {
        _messages.insert(
            0,
            Message(
                content: textMsg,
                isSentByMe: true)); //Add Sent message to chat list
        _messages.insert(
            0,
            Message(
                content: "Thinking",
                isThinking: true)); //Intermediate Thinking dialog
      });
    if(pos!="true") {
      _chatScrollController.jumpTo(_chatScrollController
          .position.minScrollExtent); //Jump to latest Message

      _textEditController.clear();
    }

      getSearchResults(textMsg);
    }
  }

  void getSearchResults(String currentMsg) {

    getIt<SensyApi>()
        .fetchAISearchResult(currentMsg, jsonEncode(_messageHistory))
        .then((chatAction) {
      setState(() {
        _messages.removeAt(0); //Remove intermediate thinking message
        _messages.insert(0,
            Message(content: chatAction.response)); // Add Response to chat list

        //Update Chat history
        _messageHistory.add({
          "role": "user",
          "content": currentMsg,
        });
        _messageHistory.add({
          "role": "assistant",
          "content": chatAction.response,
        });

        if (chatAction.actionMeta.mediaDetail.mediaRows.isNotEmpty) {
          _items.addAll(
              chatAction.actionMeta.mediaDetail.mediaRows); // Adding MediaRows

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_mediaRowScrollController.hasClients) {
              _mediaRowScrollController.jumpTo(_mediaRowScrollController
                  .position.maxScrollExtent); // Jump to latest MediaRow
            }
          });
        }
      });
    }).catchError((Object errorObj) {
      _messages.insert(0, Message(content: "Error getting response "));
    });
  }

  @override
  void dispose() {
    _textEditController.dispose();
    _chatScrollController.dispose();
    _mediaRowScrollController.dispose();
    super.dispose();
  }
}
