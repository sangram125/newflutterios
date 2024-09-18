import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

import '../../app_router.dart';
import '../../data/models/models.dart';
import '../../data/models/user_account.dart';
import '../../injection/injection.dart';

class ProfileSelectionView extends StatelessWidget {
  const ProfileSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UserAccount>(
        builder: (_, __, ___) => const ProfileSelectionBody(),
      ),
    );
  }
}

class ProfileSelectionBody extends StatefulWidget {
  const ProfileSelectionBody({super.key});

  @override
  State createState() => _ProfileSelectionState();
}

class _ProfileSelectionState extends State<ProfileSelectionBody> {
  Customer? customer;
  late List<String> profileImages;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  _fetchData() async {
    final profileImages = await _initProfileImages(context);
    setState(() {
      customer = getIt<UserAccount>().customer;
      this.profileImages = profileImages;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cust = customer;
    if (cust == null) {
      return Column(
        children: [
          const Text(
            "Who's watching?",
            style: TextStyle(color: Colors.white, fontSize: 26),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Container(
                color: Colors.red,
                child: const Center(
                  heightFactor: 2,
                  child: Text(
                    'Failed to fetch profiles',
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    final numProfiles = cust.profiles.length;
    final profileLoaded = getIt<UserAccount>().isProfileLoaded();
    return Column(children: [
      const SizedBox(
        height: 50,
      ),
      const Center(
        child: Text(
          "Who's watching?",
          style: TextStyle(color: Colors.white, fontSize: 28),
        ),
      ),
      const SizedBox(
        height: 40,
      ),
      Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 1.5,
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              if (index >= numProfiles) {
                return ProfileItemView(cust.mobileNumber, null, null,
                    "assets/images/profile_images/new_profile.png", false);
              }
              final profile = cust.profiles[index];
              final profileImage = profileImages[profile.facadeId % 99];
              return ProfileItemView(
                cust.mobileNumber,
                profile.id,
                profile.name,
                profileImage,
                profileLoaded,
              );
            },
            itemCount: numProfiles > 4
                ? 5
                : profileLoaded
                    ? numProfiles + 1
                    : numProfiles,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 4,
            ),
          ),
        ),
      ),
    ]);
  }
}

class ProfileLoader extends StatelessWidget {
  const ProfileLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).highlightColor;
    Color highlightColor =
        Theme.of(context).colorScheme.secondary.withOpacity(0.3);
    return Padding(
      padding: const EdgeInsets.only(left: 25, top: 20, right: 25),
      child: SkeletonGridLoader(
        builder: Padding(
          padding: const EdgeInsets.only(right: 0, bottom: 0),
          child: Container(
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.rectangle,
              borderRadius: const BorderRadius.all(Radius.circular(3.0)),
            ),
          ),
        ),
        items: 8,
        itemsPerRow: 4,
        crossAxisSpacing: 30,
        mainAxisSpacing: 40,
        period: const Duration(seconds: 2),
        highlightColor: highlightColor,
        baseColor: color,
        direction: SkeletonDirection.ltr,
      ),
    );
  }
}

class ProfileItemView extends StatelessWidget {
  final String mobileNumber;
  final int? profileId;
  final String? profileName;
  final String image;
  final bool modifiable;

  const ProfileItemView(this.mobileNumber, this.profileId, this.profileName,
      this.image, this.modifiable,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: profileItemTapped,
      onLongPress: profileItemLongPressed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 164,
            height: 164,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image(image: AssetImage(image)),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            profileName ?? "Add profile",
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        ],
      ),
    );
  }

  void profileItemTapped() {
    final tempProfileId = profileId;
    if (tempProfileId == null) {
      getIt<AppRouter>().push("/newProfile");
      return;
    }

    getIt<UserAccount>()
        .setProfile(tempProfileId)
        .then((_) => getIt<AppRouter>().go("/"));
  }

  void profileItemLongPressed() {
    final tempProfileId = profileId;
    if (tempProfileId != null && modifiable) {
      HapticFeedback.lightImpact();
      getIt<AppRouter>().push("/profile/$tempProfileId");
    }
  }
}

Future<List<String>> _initProfileImages(BuildContext context) async {
  final manifestContents =
      await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
  final Map<String, dynamic> manifestMap = json.decode(manifestContents);
  return manifestMap.keys
      .where((element) => element.contains('profile_images/avatar_'))
      .toList(growable: false);
}
