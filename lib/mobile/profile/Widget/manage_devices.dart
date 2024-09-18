import 'package:dor_companion/data/models/constants.dart';
import 'package:dor_companion/data/models/models.dart';
import 'package:dor_companion/widgets/appbar.dart';
import 'package:dor_companion/widgets/gradient_background_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ManageDevices extends StatefulWidget {
  List<TvDevice> tvDevices;
  ManageDevices({super.key, required this.tvDevices});
  @override
  ManageDevicesState createState() => ManageDevicesState();
}
class ManageDevicesState extends State<ManageDevices> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: GradientBackground(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(30.0),
              child: Center(
                child: Text(
                  'These signed-in devices have recently been active on this account.',
                  style: AppTypography.manageDevicesText,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.tvDevices.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      decoration: ShapeDecoration(
                        color: Colors.white.withOpacity(0.05999999865889549),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: ListTile(
                        leading:  SvgPicture.asset("assets/images/profile_images/phone.svg"), // Example leading icon
                        title: Text(widget.tvDevices.elementAt(index).name,style: AppTypography.devicesTitleManageDevices,),
                      ),
                    ),
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