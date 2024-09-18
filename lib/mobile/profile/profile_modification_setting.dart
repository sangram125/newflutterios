import 'package:dor_companion/data/models/constants.dart';
import 'package:dor_companion/data/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:settings_ui/settings_ui.dart';

class ProfileModificationSettings extends StatefulWidget {
  final Profile profile;
  final TextEditingController nameController;

  const ProfileModificationSettings(
      {super.key, required this.profile, required this.nameController});

  @override
  State createState() => _ProfileModificationSettingsState();
}

class _ProfileModificationSettingsState extends State<ProfileModificationSettings> {
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
        getEditProfile(),
        getChildToggleSection(),
        getDeleteSection(),
      ],
    );
  }

  getEditProfile() {
    return Align(
      alignment: Alignment.center,
      child: GestureDetector(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Center(
                  child: Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      Image.asset(
                        'assets/images/avatar_1', // Bottom image
                        fit: BoxFit.cover,
                      ),
                      SvgPicture.asset(
                        'assets/icons/profile_edit.svg', // Top image
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getNameSection() {
    return SettingsSection(
      title: const Text("Rename profile", style: AppTypography.undefinedTextStyle,),
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
      title: const Text("Parental controls", style: AppTypography.undefinedTextStyle,),
      tiles: [
        SettingsTile.switchTile(
          initialValue: widget.profile.isRestricted,
          onToggle: (isRestricted) {
            setState(() {
              widget.profile.isRestricted = isRestricted;
            });
          },
          title: const Text("Child profile", style:AppTypography.undefinedTextStyle),
          description: const Text("See content appropriate for under 13", style: AppTypography.undefinedTextStyle,),
        )
      ],
    );
  }

  getDeleteSection() {
    return SettingsSection(
      title: const Text("Delete profile", style: AppTypography.undefinedTextStyle,),
      tiles: [
        SettingsTile.navigation(
          leading: const Icon(Icons.delete_forever),
          title: Text("Delete ${widget.profile.name}", style: AppTypography.undefinedTextStyle,),
          //value: Text("Delete ${profile.name}"),
          onPressed: (_) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: const Color(0xFF040C3F),
                  title: Text("Delete ${widget.profile.name}?", style: AppTypography.undefinedTextStyle),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  content:  Text(
                    "You will lose your favourites, watch history,"
                        " and personalization.\n\nThis cannot be undone",
                    style: AppTypography.profileModificationViewWhiteColor,
                  ),
                  actions: [
                    TextButton(
                      child:  Text(
                        "Cancel",
                        style: AppTypography.profileModificationViewWhiteColor,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                      onPressed: () {},
                      child:  Text(
                        "Delete",
                        style: AppTypography.profileModificationViewWhiteColor,
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
}