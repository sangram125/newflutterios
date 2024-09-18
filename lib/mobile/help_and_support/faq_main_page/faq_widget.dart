import 'dart:convert';
import 'package:dor_companion/data/models/constants.dart';
import 'package:dor_companion/data/models/help_topic_model.dart';
import 'package:dor_companion/injection/injection.dart';
import 'package:dor_companion/mobile/help_and_support/faq_list_view/faq_list_widget.dart';
import 'package:dor_companion/mobile/help_and_support/widgets/contant_us_list_widget.dart';
import 'package:dor_companion/mobile/help_and_support/widgets/help_support_header_widget.dart';
import 'package:dor_companion/widgets/gradient_background_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FaqView extends StatefulWidget {
  const FaqView({Key? key}) : super(key: key);

  @override
  FaqViewState createState() => FaqViewState();
}

class FaqViewState extends State<FaqView> {
  List<HelpTopic> _helpTopics = [];
  List<HelpTopic> _filteredTopics = [];
  String query = '';

  @override
  void initState() {
    super.initState();
    loadHelpTopics();
  }

  Future<void> loadHelpTopics() async {
    try {
      final String jsonString =
      await rootBundle.loadString('assets/json/faq_data.json');
      final List<dynamic> jsonResponse = jsonDecode(jsonString);

      setState(() {
        _helpTopics =
            jsonResponse.map((data) => HelpTopic.fromJson(data)).toList();
        _filteredTopics = List.from(_helpTopics);
      });

      if (kDebugMode) {
        print('Total topics loaded: ${_helpTopics.length}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to load help topics: $e');
      }
      // Handle error gracefully
    }
  }

  void filterSearchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredTopics = List.from(_helpTopics);
        this.query = '';
      });
    } else {
      List<HelpTopic> filteredList = _helpTopics.where((topic) =>
      topic.question.toLowerCase().contains(query.toLowerCase()) ||
          topic.answer.toLowerCase().contains(query.toLowerCase())).toList();

      setState(() {
        _filteredTopics = filteredList;
        this.query = query;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GradientBackground(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const HelpAndSupportHeaderWidget(title: 'Help and support'),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 31),
                      FittedBox(
                        child: Text(
                          'How can we help you today?',
                          textAlign: TextAlign.center,
                          style: AppTypography.languageViewTitle.copyWith(fontSize: 22),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Search TextField
                      _buildSearchBar(),
                      const SizedBox(height: 24),
                      // Help Topics List
                      _buildHelpTopicsList(),
                      const SizedBox(height: 18),
                      // Contact Us Menu
                       ContactUsMenuList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 1),
        borderRadius: const BorderRadius.all(Radius.circular(100)),
      ),
      child: SearchBar(
        onTap: () {},
        hintStyle: const MaterialStatePropertyAll(TextStyle(
            color: Color(0xFFABABAB),
            fontSize: 13,
            fontWeight: FontWeight.w400)),
        hintText: 'Search like "account", "subscription"...',
        padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 14)),
        leading: SvgPicture.asset(
          'assets/icons/search.svg',
          color: const Color(0xFFE3E3E3),
        ),
        backgroundColor:
        MaterialStateProperty.all(const Color(0x490B0F47)),
        onChanged: (value) {
          filterSearchResults(value);
        },
      ),
    );
  }

  Widget _buildHelpTopicsList() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(-0.43, -0.90),
          end: const Alignment(0.43, 0.9),
          colors: [Colors.white.withOpacity(.08), Colors.white.withOpacity(.0)],
        ),
        border: Border.all(color: const Color(0xFFFFFFFF).withOpacity(.10), width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Popular Help topics',
                    style: AppTypography.languageViewTitle.copyWith(fontSize: 18, color: const Color(0xFFE3E3E3)),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FaqListWidget(),

                        ),
                      );
                    },
                    child: Text(
                      'View all',
                      style: AppTypography.homeViewTitle.copyWith(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Theme(
              data: Theme.of(context).copyWith(cardColor: Colors.transparent),
              child: _filteredTopics.isEmpty
                  ? const Center(
                child: Text('No results found.'),
              )
                  : ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _filteredTopics.length > 5 ? 5 : _filteredTopics.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      ExpansionPanelList(
                        expandIconColor: const Color(0xFFABABAB),
                        elevation: 0,
                        expansionCallback: (int panelIndex, bool isExpanded) {
                          setState(() {
                            _filteredTopics[index].isExpanded =
                            !_filteredTopics[index].isExpanded;
                          });
                        },
                        children: [
                          ExpansionPanel(
                            headerBuilder: (BuildContext context, bool isExpanded) {
                              return Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  _filteredTopics[index].question,
                                  style: AppTypography.keyTextStyle.copyWith(fontSize: 14, color: const Color(0xFFABABAB)),
                                ),
                              );
                            },
                            body: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  _filteredTopics[index].answer,
                                  style: AppTypography.mediaHeaderTitleText.copyWith(fontSize: 12, color: const Color(0xFF8F8F8F)),
                                ),
                              ),
                            ),
                            isExpanded: _filteredTopics[index].isExpanded,
                            backgroundColor: Colors.transparent,
                            canTapOnHeader: true,
                          ),
                        ],
                      ),
                      if (index != 4)
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Divider(
                            color: Color(0xFF2C2C2C),
                            height: 1,
                            thickness: 1,
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}