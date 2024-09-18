import 'package:dor_companion/data/models/constants.dart';
import 'package:flutter/material.dart';

import '../widgets/Model/Item.dart';
import '../widgets/horizontal_list_wrap.dart';

class Recommendation extends StatefulWidget {
  const Recommendation({Key? key}) : super(key: key);

  @override
  State<Recommendation> createState() => _RecommendationState();
}

class _RecommendationState extends State<Recommendation> {
  List<Item> items = [];
  bool _isThriller = false;
  bool _isDrama = false;
  bool _isComedy = false;
  bool _isAction = false;
  bool _isAnime = false;
  bool _isFantasy = false;
  bool _isRomance = false;
  bool _isSciFi = false;

  bool _isAlone = false;
  bool _isWithFamily = false;
  bool _isWithFriends = false;
  bool _isWithPartner = false;
  bool _isIdontMind = false;

  bool _isHappyEnding = false;
  bool _isSadEnding = false;
  bool _isBoth = false;

  bool _isYes = false;
  bool _isNo = false;

  bool showQuestionOneOption = true;
  bool showQuestionTwoOption = false;
  bool showQuestionThreeOption = false;
  bool showQuestionFourOption = false;
  bool showQuestionFiveOption = false;
  bool showQuestionSixOption = false;

  TextEditingController textEditingController=TextEditingController();

  int countOfCheck = 0;

  int index = 0;

  final List questionAnsList = [
    {
      'question': 'What is your preferred movie genre?',
      'subtitle': 'Select upto 3'
    },
    {
      'question': 'How do you prefer to watch movies?',
      'subtitle': 'Select upto 1'
    },
    {
      'question': 'Do you prefer movies with happy or sad endings?',
      'subtitle': 'Select upto 1'
    },
    {
      'question':
          'Are you interested in watching foreign language films with subtitles?',
      'subtitle': 'Select upto 1'
    },
    {
      'question':
          'Are you open to exploring independent or lesser-known films?',
      'subtitle': 'Select upto 1'
    },
    {
      'question': 'What is your favorite actor/actress or director?',
      'subtitle': ''
    },
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF040515), Color(0xFF040523)], // Define the gradient colors
                begin: Alignment.topLeft, // Set the starting point of the gradient
                end: Alignment.bottomRight, // Set the ending point of the gradient
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 30, top: 60),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: 60,
                      margin: const EdgeInsets.only(top: 10, right: 10, bottom: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white,
                          width: 1,
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "${index + 1} / 6",
                          style: AppTypography.indexText,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 30, top: 30),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      questionAnsList[index]['question'],
                      style: AppTypography.questionText,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 30, top: 30,bottom: 30),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      questionAnsList[index]['subtitle'],
                      style: AppTypography.questionTextSubTitle,
                    ),
                  ),
                ),
                HorizontalListWrap(items),
                Visibility(
                  visible: showQuestionOneOption,
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
                        child: ElevatedButton(
                          onPressed: () {
                            checkLogic();
                            setState(() {
                              if (countOfCheck < 3 || _isThriller == true) {
                                _isThriller = !_isThriller;
                              }
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(color: Colors.white),
                            ),
                            backgroundColor:
                                _isThriller ? Colors.blueAccent : const Color(0xFF040523),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text("Thriller",style: AppTypography.undefinedTextStyle,),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
                        child: ElevatedButton(
                          onPressed: () {
                            checkLogic();
                            setState(() {
                              if (countOfCheck < 3 || _isDrama == true) {
                                _isDrama = !_isDrama;
                              }
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(color: Colors.white),
                            ),
                            backgroundColor:
                                _isDrama ? Colors.blueAccent : const Color(0xFF040523),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text("Drama", style: AppTypography.undefinedTextStyle),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
                        child: ElevatedButton(
                          onPressed: () {
                            checkLogic();
                            setState(() {
                              if (countOfCheck < 3 || _isComedy == true) {
                                _isComedy = !_isComedy;
                              }
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(color: Colors.white),
                            ),
                            backgroundColor:
                                _isComedy ? Colors.blueAccent : const Color(0xFF040523),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text("Comedy", style: AppTypography.undefinedTextStyle),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
                        child: ElevatedButton(
                          onPressed: () {
                            checkLogic();
                            setState(() {
                              if (countOfCheck < 3 || _isAction == true) {
                                _isAction = !_isAction;
                              }
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(color: Colors.white),
                            ),
                            backgroundColor:
                                _isAction ? Colors.blueAccent : const Color(0xFF040523),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text("Action",style: AppTypography.undefinedTextStyle),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
                        child: ElevatedButton(
                          onPressed: () {
                            checkLogic();
                            setState(() {
                              if (countOfCheck < 3 || _isAnime == true) {
                                _isAnime = !_isAnime;
                              }
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(color: Colors.white),
                            ),
                            backgroundColor:
                                _isAnime ? Colors.blueAccent : const Color(0xFF040523),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text("Anime", style: AppTypography.undefinedTextStyle),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
                        child: ElevatedButton(
                          onPressed: () {
                            checkLogic();
                            setState(() {
                              if (countOfCheck < 3 || _isFantasy == true) {
                                _isFantasy = !_isFantasy;
                              }
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(color: Colors.white),
                            ),
                            backgroundColor:
                                _isFantasy ? Colors.blueAccent : const Color(0xFF040523),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text("Fantasy", style: AppTypography.undefinedTextStyle),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
                        child: ElevatedButton(
                          onPressed: () {
                            checkLogic();
                            setState(() {
                              if (countOfCheck < 3 || _isRomance == true) {
                                _isRomance = !_isRomance;
                              }
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(color: Colors.white),
                            ),
                            backgroundColor:
                                _isRomance ? Colors.blueAccent : const Color(0xFF040523),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text("Romance", style: AppTypography.undefinedTextStyle),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
                        child: ElevatedButton(
                          onPressed: () {
                            checkLogic();
                            setState(() {
                              if (countOfCheck < 3 || _isSciFi == true) {
                                _isSciFi = !_isSciFi;
                              }
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(color: Colors.white),
                            ),
                            backgroundColor:
                                _isSciFi ? Colors.blueAccent : const Color(0xFF040523),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text("Sci-fi", style: AppTypography.undefinedTextStyle),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: showQuestionTwoOption,
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isAlone = !_isAlone;
                              _isWithFamily = false;
                              _isWithFriends = false;
                              _isWithPartner = false;
                              _isIdontMind = false;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(color: Colors.white),
                            ),
                            backgroundColor:
                                _isAlone ? Colors.blueAccent : const Color(0xFF040523),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text("Alone", style: AppTypography.undefinedTextStyle),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isAlone = false;
                              _isWithFamily = !_isWithFamily;
                              _isWithFriends = false;
                              _isWithPartner = false;
                              _isIdontMind = false;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(color: Colors.white),
                            ),
                            backgroundColor:
                                _isWithFamily ? Colors.blueAccent : const Color(0xFF040523),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text("With Family", style: AppTypography.undefinedTextStyle),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isAlone = false;
                              _isWithFamily = false;
                              _isWithFriends = !_isWithFriends;
                              _isWithPartner = false;
                              _isIdontMind = false;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(color: Colors.white),
                            ),
                            backgroundColor: _isWithFriends
                                ? Colors.blue
                                : const Color(0xFF040523),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text("With Friends", style: AppTypography.undefinedTextStyle),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isAlone = false;
                              _isWithFamily = false;
                              _isWithFriends = false;
                              _isWithPartner = !_isWithPartner;
                              _isIdontMind = false;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(color: Colors.white),
                            ),
                            backgroundColor: _isWithPartner
                                ? Colors.blue
                                : const Color(0xFF040523),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text("With Partner", style: AppTypography.undefinedTextStyle),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isAlone = false;
                              _isWithFamily = false;
                              _isWithFriends = false;
                              _isWithPartner = false;
                              _isIdontMind = !_isIdontMind;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(color: Colors.white),
                            ),
                            backgroundColor:
                                _isIdontMind ? Colors.blueAccent : const Color(0xFF040523),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text("Anyone", style: AppTypography.undefinedTextStyle),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: showQuestionThreeOption,
                  child: Wrap(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isHappyEnding = !_isHappyEnding;
                              _isSadEnding = false;
                              _isBoth = false;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(color: Colors.white),
                            ),
                            backgroundColor: _isHappyEnding
                                ? Colors.blue
                                : const Color(0xFF040523),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text("Happy Ending", style: AppTypography.undefinedTextStyle),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isHappyEnding = false;
                              _isSadEnding = !_isSadEnding;
                              _isBoth = false;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(color: Colors.white),
                            ),
                            backgroundColor:
                                _isSadEnding ? Colors.blueAccent : const Color(0xFF040523),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text("Sad Ending", style: AppTypography.undefinedTextStyle),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isHappyEnding = false;
                              _isSadEnding = false;
                              _isBoth = !_isBoth;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(color: Colors.white),
                            ),
                            backgroundColor:
                                _isBoth ? Colors.blueAccent : const Color(0xFF040523),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text("Both", style: AppTypography.undefinedTextStyle),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: showQuestionFourOption,
                  child: Wrap(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isYes = !_isYes;
                              _isNo = false;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(color: Colors.white),
                            ),
                            backgroundColor:
                                _isYes ? Colors.blueAccent : const Color(0xFF040523),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text("Yes", style: AppTypography.undefinedTextStyle),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isYes = false;
                              _isNo = !_isNo;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(color: Colors.white),
                            ),
                            backgroundColor:
                                _isNo ? Colors.blueAccent : const Color(0xFF040523),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text("No", style: AppTypography.undefinedTextStyle),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: showQuestionFiveOption,
                  child: Wrap(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isYes = !_isYes;
                              _isNo = false;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(color: Colors.white),
                            ),
                            backgroundColor:
                                _isYes ? Colors.blueAccent : const Color(0xFF040523),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text("Yes", style: AppTypography.undefinedTextStyle),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isYes = false;
                              _isNo = !_isNo;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(color: Colors.white),
                            ),
                            backgroundColor:
                                _isNo ? Colors.blueAccent : const Color(0xFF040523),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text("No", style: AppTypography.undefinedTextStyle),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: showQuestionSixOption,
                    child: buildMobileNumberField(context)),
                InkWell(
                  onTap: () {
                    setState(() {
                      logicOption();
                      if (index < questionAnsList.length - 1) {
                        index++;
                      } else {
                        Navigator.pop(context);
                      }
                    });
                  },
                  child: index == 5
                      ? Container(
                          margin: const EdgeInsets.all(20),
                          padding: const EdgeInsets.all(18),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.blueAccent, // Background color
                            borderRadius:
                                BorderRadius.circular(10), // Rounded corners
                          ),
                          child: const Text(
                            'SUBMIT',
                            textAlign: TextAlign.center,
                            style: AppTypography.submitbutton,
                          ),
                        )
                      : Container(
                          margin: const EdgeInsets.all(20),
                          padding: const EdgeInsets.all(18),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.blueAccent, // Background color
                            borderRadius:
                                BorderRadius.circular(10), // Rounded corners
                          ),
                          child: const Text(
                            'NEXT QUESTION',
                            textAlign: TextAlign.center,
                            style: AppTypography.submitbutton,
                          ),
                        ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      logicOption();
                      if (index < questionAnsList.length - 1) {
                        index++;
                      } else {
                        Navigator.pop(context);
                      }
                    });
                  },
                  child: const Text(
                    'SKIP',
                    textAlign: TextAlign.center,
                    style: AppTypography.skipButtonTextRecommendationView,
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void logicOption() {
    if (index == 0) {
      showQuestionOneOption = false;
      showQuestionTwoOption = true;
      showQuestionThreeOption = false;
      showQuestionFourOption = false;
      showQuestionFiveOption = false;
      showQuestionSixOption = false;
    } else if (index == 1) {
      showQuestionOneOption = false;
      showQuestionTwoOption = false;
      showQuestionThreeOption = true;
      showQuestionFourOption = false;
      showQuestionFiveOption = false;
      showQuestionSixOption = false;
    } else if (index == 2) {
      showQuestionOneOption = false;
      showQuestionTwoOption = false;
      showQuestionThreeOption = false;
      showQuestionFourOption = true;
      showQuestionFiveOption = false;
      showQuestionSixOption = false;
    } else if (index == 3) {
      showQuestionOneOption = false;
      showQuestionTwoOption = false;
      showQuestionThreeOption = false;
      showQuestionFourOption = false;
      showQuestionFiveOption = true;
      showQuestionSixOption = false;
    } else if (index == 4) {
      showQuestionOneOption = false;
      showQuestionTwoOption = false;
      showQuestionThreeOption = false;
      showQuestionFourOption = false;
      showQuestionFiveOption = false;
      showQuestionSixOption = true;
    }
  }

  void checkLogic() {
    countOfCheck = 0;
    if (_isThriller == true) {
      countOfCheck++;
    }
    if (_isDrama == true) {
      countOfCheck++;
    }
    if (_isComedy == true) {
      countOfCheck++;
    }
    if (_isAction == true) {
      countOfCheck++;
    }
    if (_isAnime == true) {
      countOfCheck++;
    }
    if (_isFantasy == true) {
      countOfCheck++;
    }
    if (_isRomance == true) {
      countOfCheck++;
    }
    if (_isSciFi == true) {
      countOfCheck++;
    }
  }


  Stack buildMobileNumberField(
      BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: TextField(
            style: AppTypography.whiteColorText,
            inputFormatters: const [
            ],
            controller: textEditingController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 25),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color:
                  Theme.of(context).colorScheme.onPrimary.withOpacity(0.4),
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 1,
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: Theme.of(context).colorScheme.error,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2,
                  color: Theme.of(context).colorScheme.error,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              labelText: "ENTER NAME",
              labelStyle: const TextStyle(color: Colors.white),
              helperText: ' ',
              prefixStyle: AppTypography.submitbutton,
            ),
          ),
        ),
        //
      ],
    );
  }
}
