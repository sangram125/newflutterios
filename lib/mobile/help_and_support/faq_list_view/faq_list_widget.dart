import 'dart:convert';
import 'package:dor_companion/data/models/constants.dart';
import 'package:dor_companion/data/models/help_topic_model.dart';
import 'package:dor_companion/mobile/help_and_support/widgets/help_support_header_widget.dart';
import 'package:dor_companion/widgets/gradient_background_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FaqListWidget extends StatefulWidget {
  const FaqListWidget({Key? key}) : super(key: key);

  @override
  FaqListState createState() => FaqListState();
}

class FaqListState extends State<FaqListWidget> {
  List<HelpTopic> _helpTopics = [];
  List<HelpTopic> _filteredTopics = [];

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
    List<HelpTopic> dummySearchList = List.from(_helpTopics);
    if (query.isNotEmpty) {
      List<HelpTopic> dummyListData = dummySearchList
          .where((item) =>
      item.question.toLowerCase().contains(query.toLowerCase()) ||
          item.answer.toLowerCase().contains(query.toLowerCase()))
          .toList();
      setState(() {
        _filteredTopics = dummyListData;
      });
    } else {
      setState(() {
        _filteredTopics = List.from(_helpTopics);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GradientBackground(
          child: Column(
            children: [
              const SizedBox(height: 16),
              const HelpAndSupportHeaderWidget(title: 'FAQs'),
              const SizedBox(height: 33),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildSearchBar(),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: _buildHelpTopicsList(),
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
    return Column(
      children: _filteredTopics.isEmpty
          ? [
        const Center(child: Text('No results found.')),
      ] : _filteredTopics
          .asMap()
          .entries
          .map((entry) => Column(
        children: [
          ExpansionPanelList(
            expandIconColor: const Color(0xFFABABAB),
            elevation: 0,
            expansionCallback:
                (int panelIndex, bool isExpanded) {
              setState(() {
                _filteredTopics[entry.key].isExpanded =
                !_filteredTopics[entry.key].isExpanded;
              });
            },
            children: [
              ExpansionPanel(
                headerBuilder:
                    (BuildContext context, bool isExpanded) {
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      entry.value.question,
                      style: AppTypography.keyTextStyle.copyWith(
                        fontSize: 14,
                        color: const Color(0xFFABABAB),
                      ),
                    ),
                  );
                },
                body: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      entry.value.answer,
                      style:
                      AppTypography.mediaHeaderTitleText.copyWith(
                        fontSize: 12,
                        color: const Color(0xFF8F8F8F),
                      ),
                    ),
                  ),
                ),
                isExpanded: entry.value.isExpanded,
                backgroundColor: Colors.transparent,
                canTapOnHeader: true,
              ),
            ],
          ),
          if (entry.key != _filteredTopics.length - 1)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Divider(
                color: Color(0xFF2C2C2C),
                height: 1,
                thickness: 1,
              ),
            ),
        ],
      )).toList(),
    );
  }
}
