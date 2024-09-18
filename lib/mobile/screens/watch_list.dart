import 'dart:developer';
import 'package:dor_companion/data/models/constants.dart';
import 'package:dor_companion/data/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../data/api/sensy_api.dart';
import '../../data/models/search_suggestions.dart';
import '../../data/models/user_interests.dart';
import '../../injection/injection.dart';
import '../../widgets/appbar.dart';
import '../search/search_view.dart';
import '../../../widgets/custom_search_widget.dart' as se;

class WatchListView extends StatelessWidget {
  const WatchListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: _buildBody(context),
      ),
    );
  }


  _buildBody(BuildContext context) {
    return Expanded(
        child: SingleChildScrollView(
      child: Consumer<UserInterestsChangeNotifier>(
        builder: (context, userInterestNotifier, child) {
          log("=====================================================Watch list length");
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WatchListRow(watchList: userInterestNotifier.getWatchList(),),
              Padding(
                padding: EdgeInsets.only(left: 18.w),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.sp)),
                    side: BorderSide(
                      width: 1.sp,
                      color: const Color(0xFF3158CE),
                    ),
                  ),
                  onPressed: () {
                    se.showSearch(
                      context: context,
                      delegate: CustomSearchDelegate(
                          sensyApi: getIt<SensyApi>(),
                          searchSuggestion: getIt<SearchSuggestions>(),
                          isComingFromProfile: true
                      ),
                    );
                  },
                  child: Text(
                    "Create new",
                    style: AppTypography.createNewText,
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          );
        },

      ),
    ));
  }
}

class WatchListRow extends StatelessWidget {
  final List<Future<MediaDetail>> watchList;
   const WatchListRow( {super.key, required this.watchList});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210.h,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: SvgPicture.asset(
                  "assets/icons/icon_edit_pensicle.svg",
                  width: 18.sp,
                  height: 18.sp,
                  alignment: Alignment.center,
                ),
              ),
              Text(
                "watchlist1",
                style: AppTypography.watchList1Text,
              )
            ],
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 18.w),
              child: ListView.builder(
                  itemCount: watchList.length + 1 ,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    if (watchList.length == index) {
                      return const AddNewCardButton();
                    }
                    final mediaItem = watchList[index];
                    return Padding(
                      padding: EdgeInsets.only(right: 15.w),
                      child: FutureBuilder<MediaDetail>(
                        future: mediaItem,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.deepPurpleAccent,
                              ),
                            );
                          }

                          if (snapshot.connectionState == ConnectionState.done) {
                            if (snapshot.hasError) {
                              return Center(
                                child: Text(
                                  'An ${snapshot.error} occurred',
                                  style: AppTypography.errorOccuredText,
                                ),
                              );
                            } else if (snapshot.hasData) {
                              final data = snapshot.data;
                              final json = data?.toJson();
                              log(json.toString()  );
                              return Image.network(
                                "https://sensara-static-files.sensara.co/pre-sized/images/192x288/7ebf3c8ea3fe7e2db50af166ca42c73d/https%253A%252F%252Fsensara-static-files.sensara.co%252Fmedia%252Ffacets%252F4695367003801978081.jpg",
                                // Replace with your image URL
                                fit: BoxFit.cover,
                                height: 140.h,
                                width: 112.w,
                              );
                            }
                          }

                          return const Center(
                            child: CircularProgressIndicator(),
                          );


                        },

                      ),
                    );
                  }),
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
        ],
      ),
    );
  }
}

class AddNewCardButton extends StatelessWidget {
  const AddNewCardButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        color: Colors.black.withOpacity(0.20),
        height: 140.h,
        width: 112.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              color: const Color(0xFF3158CE),
              width: 27.sp,
              height: 27.sp,
              image: const AssetImage('assets/icons/add_circle.png'),
            ),
            SizedBox(
              height: 15.h,
            ),
            Text(
              "Add new",
              style: AppTypography.addNewTextWatlist,
            )
          ],
        ),
      ),
    );
  }
}
