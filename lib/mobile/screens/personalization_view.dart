import 'package:dor_companion/data/api/sensy_api.dart';
import 'package:dor_companion/injection/injection.dart';
import 'package:dor_companion/widgets/gradient_background_widget.dart';
import 'package:flutter/material.dart';
import '../../widgets/loader.dart';
import '../../widgets/media_detail/media_rows_view.dart';

class PersonalizationView extends StatefulWidget {
  const PersonalizationView({super.key});

  @override
  State createState() => _PersonalizationViewState();
}

class _PersonalizationViewState extends State<PersonalizationView> {
  bool isSaving = false;

  @override
  Widget build(BuildContext context) {
    return  isSaving
          ? const Center(child: Loader())
          : Column(
            children: [
              const Text(
                'Select Topics',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                  height: 0,
                  letterSpacing: 0.10,
                ),
              ),
              const SizedBox(height: 5,),
              const Text(
                'To get better content suggestions',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF8F8F8F),
                  fontSize: 14,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  height: 0,
                  letterSpacing: 0.25,
                ),
              ),
              const SizedBox(height: 8,),
              Expanded(
                child: MediaRowsView(
                  isTopicScreen: true,
                    mediaDetailFuture: () =>
                        getIt<SensyApi>().fetchMediaDetail("tab", "personalize"),
                    key: const Key("personalize"),
                  ),
              ),
            ],
          );
  }
}
