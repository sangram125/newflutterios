import 'package:dor_companion/data/models/constants.dart';
import 'package:dor_companion/firebase_analytics/firebase_performance.dart';
import 'package:dor_companion/mobile/game/game_controller.dart';
import 'package:dor_companion/mobile/widgets/library_controller.dart';
import 'package:dor_companion/mobile/widgets/media_detail/media_item_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/api/sensy_api.dart';
import '../../data/models/user_account.dart';
import '../../injection/injection.dart';
import '../widgets/media_detail/media_row_view.dart' as mob_row_view;
import '../../widgets/banner_carousel.dart';
import '../../widgets/loader.dart';
import '../../widgets/media_detail/mdp_loaders.dart';
import '../../widgets/media_detail/media_rows_view.dart';
import 'package:http/http.dart' as http;

import 'game_inApp_web_view.dart';

class GameView extends StatelessWidget{
  GameView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
   return Container(
     decoration:
     BoxDecoration(
       gradient: LinearGradient(
         begin: Alignment.centerLeft,
         end: Alignment.centerRight,
         colors: [
           const Color(0xFF0F1566),
           const Color(0x0B0F474A).withOpacity(0.29),
         ],
       ),
     ),
     child:GameTab(
       mediaDetailFuture: () =>
           getIt<SensyApi>().fetchMediaDetail("tab", "Game"),
       key: const Key("games ${9}"),
     ),
   );
  }
}


class GameTab extends StatelessWidget {
  GameTab({
    Key? key,
    required this.mediaDetailFuture,
  }) : super(key: key);


  //final TrackingScrollController controller;
  final FetchRows mediaDetailFuture;


  int count = 0;

  final controller =Get.put(GameController());

  Widget _buildBanners(BuildContext context) {
    final banners = controller.libraryBanners;
    final isBannersError =controller.isBannersError.value;
    if (banners.isEmpty && !isBannersError) {
      if (kDebugMode) {
        print("returning banner loader");
      }
      return SizedBox(
          height: MediaQuery.of(context).size.width,
          width: 280,
          child: const Center(child: Loader()));
    }

    if (isBannersError) {
      return SizedBox(
        height: MediaQuery.of(context).size.width,
        child: Center(
          child: ElevatedButton(
            onPressed: controller.fetchBanners(key:const Key("games ${9}") ),
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
              backgroundColor: Theme.of(context).colorScheme.tertiary,
              textStyle: AppTypography.fontSizeChanges,
            ),
            child: const Text("Tap to retry", style: AppTypography.undefinedTextStyle,),
          ),
        ),
      );
    }

    return Column(
      children: [
        if (getIt<UserAccount>().profileName != "kids")
          BannersCarousel(
            banners: banners,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PerformanceTrackedWidget(
      widgetName: 'library-view',
      child: Obx(() {
        if (controller.rows.isEmpty && !controller.isError.value) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 50.0),
              child: SingleChildScrollView(child: MDPBodyLoader()),
            ),
          );
        }

        if (controller.isError.value) {

          return SizedBox(
            height: 200,
            child: Center(
              child: ElevatedButton(
                onPressed: () => controller.fetchData,
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                  textStyle: AppTypography.fontSizeChanges,
                ),
                child: const Text("Tap to retry", style: AppTypography.undefinedTextStyle,),
              ),
            ),
          );
        }
       return Scaffold(
         // appBar: AppBar(),
          backgroundColor: Colors.transparent,
          floatingActionButton: AnimatedOpacity(
            duration: const Duration(microseconds: 100),
            opacity: controller.fabIsVisible.value  ? 1 : 0,
            child: Container(
              margin: const EdgeInsets.only(bottom: 76.0),
              child: FloatingActionButton(
                onPressed: () {
                  // setState(() {
                  controller.fabIsVisible.value = false;
                  // });
                  print("scroll value ${controller.scrollController.position.minScrollExtent}");
                  if (controller.scrollController.hasClients) {
                    final position = controller.scrollController.position.minScrollExtent;
                    controller.scrollController.animateTo(
                      position,
                      duration: const Duration(seconds: 1),
                      curve: Curves.easeOut,
                    );
                    print("scroll value $position");
                  }
                },
                isExtended: true,
                tooltip: "Scroll to Top",
                child: const Icon(Icons.arrow_upward),
              ),
            ),
          ),
         body: SafeArea(
           child: Obx(() {
             return Container(
               decoration: BoxDecoration(
                 gradient: LinearGradient(
                   begin: Alignment.centerLeft,
                   end: Alignment.centerRight,
                   colors: [
                     const Color(0xFF0F1566),
                     const Color(0x0B0F474A).withOpacity(0.29),
                   ],
                 ),
               ),
               margin: const EdgeInsets.only(bottom: 20),
               child: controller.games.isNotEmpty
                   ? CustomScrollView(
                 slivers: [
                   SliverToBoxAdapter(
                     child: _buildBanners(context),
                   ),
                   SliverList(
                     delegate: SliverChildBuilderDelegate(
                           (context, index) {
                         final game = controller.games[index];
                         return InkWell(
                           onTap: () {
                             Navigator.push(
                               context,
                               MaterialPageRoute(
                                 builder: (context) =>
                                     GameWebView(articleUrl: game.mobileUrl),
                               ),
                             );
                           },
                           child: ListTile(
                             contentPadding: EdgeInsets.zero,
                             minVerticalPadding: 15,
                             horizontalTitleGap: 0,
                             leading: Image.network(
                               game.image,
                               width: 150,
                               height: 150,
                             ),
                             title: Text(game.title),

                             subtitle: Text(game.misc.description!,
                               maxLines: 2,
                               overflow: TextOverflow.ellipsis,),
                           ),
                         );
                       },
                       childCount: controller.games.length,
                     ),
                   ),
                 ],
               )
                   : SizedBox(
                 height: 75,
                 child: Center(child: Loader()),
               ),
             );
           }),
         ),
        );
      }
      ),
    );
  }


  bool get wantKeepAlive => true;
}
