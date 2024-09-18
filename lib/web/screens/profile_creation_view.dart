import 'package:dio/dio.dart';
import 'package:dor_companion/app_router.dart';
import 'package:dor_companion/injection/injection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../data/models/user_account.dart';
import '../../utils.dart';

class ProfileCreationView extends StatelessWidget {
  const ProfileCreationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create profile",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: const ProfileCreationBody(),
    );
  }
}

class ProfileCreationBody extends StatefulWidget {
  const ProfileCreationBody({super.key});

  @override
  State createState() => _ProfileCreationBodyState();
}

class _ProfileCreationBodyState extends State<ProfileCreationBody> {
  final nameController = TextEditingController();

  String name = '';
  bool isCreatingProfile = false;
  String? nameError;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 80,
        ),
        buildNameField(),
        const SizedBox(height: 24),
        buildSubmitButton(),
      ],
    );
  }

  buildNameField() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24),
      child: TextField(
        controller: nameController,
        keyboardType: TextInputType.name,
        enabled: !isCreatingProfile,
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
          helperText: ' ',
          errorText: nameError?.isNotEmpty ?? false ? nameError : null,
        ),
      ),
    );
  }

  Container buildSubmitButton() {
    return Container(
      height: 50,
      width: 150,
      decoration: BoxDecoration(
        color: isCreatingProfile
            ? Colors.white54
            : Theme.of(context).colorScheme.tertiary,
        borderRadius: BorderRadius.circular(50),
      ),
      child: TextButton(
        onPressed: () => createProfile(),
        child: Text(
          isCreatingProfile ? 'Creating' : 'Create',
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }

  createProfile() {
    final tempName = nameController.text;
    final tempNameError = validateName(tempName);
    if (tempNameError != null) {
      setState(() {
        isCreatingProfile = false;
        nameError = tempNameError;
      });
      return;
    }

    getIt<UserAccount>()
        .createProfile(tempName)
        .then((_) => getIt<AppRouter>().go("/"))
        .catchError((Object errorObj) {
      switch (errorObj.runtimeType) {
        case DioException:
          final response = (errorObj as DioException).response;
          if (kDebugMode) {
            print("Error code ${response?.statusCode}, ${response.toString()}");
          }
          setState(() {
            isCreatingProfile = false;
            nameError =
                "Failed to create profile try again: ${response?.statusCode}";
          });
          break;
        default:
          if (kDebugMode) {
            print("Non DioException during createProfile: $errorObj");
          }
          showVanillaToast("Failed to create profile, try logging in again");
          getIt<UserAccount>().logout();
      }
    });
  }

  String? validateName(String name) {
    if (name.isEmpty) return "Name can't be empty";
    if (name.length > 25) return "Name too long, up to 25 characters only";
    RegExp exp = RegExp(r"^[a-zA-Z0-9]+( [a-zA-Z0-9]+)*$");
    if (exp.hasMatch(name)) return null;
    return "Name can contain only alphanumeric characters and spaces";
  }
}
