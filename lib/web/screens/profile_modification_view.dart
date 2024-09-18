import 'package:dio/dio.dart';
import 'package:dor_companion/data/api/sensy_api.dart';
import 'package:dor_companion/data/models/models.dart';
import 'package:dor_companion/data/models/user_account.dart';
import 'package:dor_companion/injection/injection.dart';
import 'package:dor_companion/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../widgets/loader.dart';

class ProfileModificationView extends StatefulWidget {
  final int profileId;

  const ProfileModificationView({super.key, required this.profileId});

  @override
  State<StatefulWidget> createState() => _ProfileModificationState();
}

class _ProfileModificationState extends State<ProfileModificationView> {
  Customer? customer;
  Profile? profile;
  bool saving = false;

  final nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    setState(() {
      final cust = getIt<UserAccount>().customer;
      customer = cust;

      if (cust != null) {
        final profiles =
            cust.profiles.where((profile) => profile.id == widget.profileId);

        final tempProfile = profiles.first;
        profile = tempProfile;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Modify profile",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: saveChanges,
            child: const Text(
              "Save",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: getBody(),
    );
  }

  saveChanges() {
    final tempProfile = profile;
    if (tempProfile == null) return;

    final newName = nameController.text.trim();

    final errorString = validateName(newName);
    if (errorString != null) {
      showVanillaToast(errorString);
      return;
    }

    if (tempProfile.name == newName) {
      context.pop();
      showVanillaToast("No changes made");
      return;
    }

    setState(() {
      saving = true;
    });

    getIt<SensyApi>()
        .renameProfile(widget.profileId.toString(), newName)
        .then((value) {
      final userAccount = getIt<UserAccount>();
      if (userAccount.profileId == widget.profileId) {
        userAccount.setProfileName(newName);
      }
      showVanillaToast("Changes saved");
      //context.pop();
    }).catchError((Object errorObj) {
      switch (errorObj.runtimeType) {
        case DioException:
          final response = (errorObj as DioException).response;
          showVanillaToast("Failed to update profile: ${response?.statusCode}");
      }
    });
  }

  String? validateName(String name) {
    if (name.isEmpty) return "Name can't be empty";
    if (name.length > 50) return "Name too long, up to 50 characters only";
    RegExp exp = RegExp(r"^[a-zA-Z0-9]+( [a-zA-Z0-9]+)*$");
    if (exp.hasMatch(name)) return null;
    return "Name can contain only alphanumeric characters and spaces";
  }

  getBody() {
    if (saving) {
      return const Center(child: Loader());
    }

    final prof = profile;
    if (prof == null) {
      return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Container(
                color: Colors.red,
                child: const Center(
                  heightFactor: 2,
                  child: Text(
                    'Failed to fetch profile',
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return ProfileModificationSettings(
      profile: prof,
      nameController: nameController,
    );
  }
}

class ProfileModificationSettings extends StatefulWidget {
  final Profile profile;
  final TextEditingController nameController;

  const ProfileModificationSettings(
      {super.key, required this.profile, required this.nameController});

  @override
  State createState() => _ProfileModificationSettingsState();
}

class _ProfileModificationSettingsState
    extends State<ProfileModificationSettings> {
  @override
  Widget build(BuildContext context) {
    widget.nameController.text = widget.profile.name;
    return SettingsList(
      darkTheme: const SettingsThemeData(
        settingsListBackground: Color(0xFF010521),
        settingsSectionBackground: Color(0xFF010521),
        titleTextColor: Colors.white,
        trailingTextColor: Colors.white,
        leadingIconsColor: Colors.white,
        inactiveTitleColor: Colors.white,
        inactiveSubtitleColor: Colors.white,
        settingsTileTextColor: Colors.white,
        tileDescriptionTextColor: Colors.white54,
        tileHighlightColor: Color(0xFF030C2D),
      ),
      lightTheme: const SettingsThemeData(
        settingsListBackground: Color(0xFF010521),
        settingsSectionBackground: Color(0xFF010521),
        titleTextColor: Colors.white,
        trailingTextColor: Colors.white,
        leadingIconsColor: Colors.white,
        inactiveTitleColor: Colors.white,
        inactiveSubtitleColor: Colors.white,
        settingsTileTextColor: Colors.white,
        tileDescriptionTextColor: Colors.white54,
        tileHighlightColor: Color(0xFF030C2D),
      ),
      sections: [
        getNameSection(),
        getChildToggleSection(),
        getDeleteSection(),
      ],
    );
  }

  getNameSection() {
    return SettingsSection(
      title: const Text("Rename profile"),
      tiles: [
        CustomSettingsTile(
          child: Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 12),
            child: TextField(
              controller: widget.nameController,
              keyboardType: TextInputType.name,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 25),
                disabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    width: 2,
                    color: Colors.white54,
                  ),
                  borderRadius: BorderRadius.circular(50.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    width: 2,
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(50.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  borderRadius: BorderRadius.circular(50.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  borderRadius: BorderRadius.circular(50.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  borderRadius: BorderRadius.circular(50.0),
                ),
                labelStyle: const TextStyle(color: Colors.white54),
                labelText: 'Profile name',
                hintText: 'Profile 1',
              ),
            ),
          ),
        ),
      ],
    );
  }

  getChildToggleSection() {
    return SettingsSection(
      title: const Text("Parental controls"),
      tiles: [
        SettingsTile.switchTile(
          initialValue: widget.profile.isRestricted,
          onToggle: (isRestricted) {
            setState(() {
              widget.profile.isRestricted = isRestricted;
            });
          },
          title: const Text("Child profile"),
          description: const Text("See content appropriate for under 13"),
        )
      ],
    );
  }

  getDeleteSection() {
    return SettingsSection(
      title: const Text("Delete profile"),
      tiles: [
        SettingsTile.navigation(
          leading: const Icon(Icons.delete_forever),
          title: Text("Delete ${widget.profile.name}"),
          //value: Text("Delete ${profile.name}"),
          onPressed: (_) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: const Color(0xFF040C3F),
                  title: Text("Delete ${widget.profile.name}?"),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  content: const Text(
                    "You will lose your favourites, watch history,"
                    " and personalization.\n\nThis cannot be undone",
                    style: TextStyle(color: Colors.white54),
                  ),
                  actions: [
                    TextButton(
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                      onPressed: _deleteProfile,
                      child: const Text(
                        "Delete",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        )
      ],
    );
  }

  _deleteProfile() {
    final id = widget.profile.id;
    getIt<UserAccount>()
        .deleteProfile(id)
        .then((value) => context.go("/"))
        .catchError((Object errorObj) {
      switch (errorObj.runtimeType) {
        case DioException:
          final response = (errorObj as DioException).response;
          showVanillaToast("Failed to delete profile: ${response?.statusCode}");
          Navigator.pop(context);
      }
    });
  }
}
