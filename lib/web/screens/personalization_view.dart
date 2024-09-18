import 'package:dio/dio.dart';
import 'package:dor_companion/data/api/sensy_api.dart';
import 'package:dor_companion/data/models/user_account.dart';
import 'package:dor_companion/data/models/user_interests.dart';
import 'package:dor_companion/injection/injection.dart';
import 'package:dor_companion/utils.dart';
import 'package:flutter/material.dart';

import '../../app_router.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pick your favourites",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text(
              "Save",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: isSaving
          ? const Center(child: Loader())
          : MediaRowsView(
              mediaDetailFuture: () =>
                  getIt<SensyApi>().fetchMediaDetail("tab", "personalize"),
              key: const Key("personalize"),
            ),
    );
  }

  _save() {
    if (isSaving) return;

    if (!getIt<UserInterestsChangeNotifier>().hasFavorites()) {
      showVanillaToast("Favourite at least one item");
      return;
    }

    setState(() => isSaving = true);

    getIt<UserAccount>()
        .setProfilePersonalized(true)
        .then((_) => getIt<AppRouter>().go("/"))
        .catchError((errorObj) {
      setState(() => isSaving = false);
      switch (errorObj.runtimeType) {
        case DioException:
          final response = (errorObj as DioException).response;
          showVanillaToast(
              "Failed to update your profile: ${response?.statusCode}");
      }
    });
  }
}
