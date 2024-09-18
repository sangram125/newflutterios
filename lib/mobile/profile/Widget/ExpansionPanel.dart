import 'package:dor_companion/data/models/constants.dart';
import 'package:dor_companion/mobile/profile/Widget/Setting_on_off_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotificationDropdown extends StatefulWidget {
  @override
  _NotificationDropdownState createState() => _NotificationDropdownState();
}
class _NotificationDropdownState extends State<NotificationDropdown> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
      decoration:BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Colors.white.withOpacity(0.10000000149011612),
          ),
        ),
      ),
      child: ExpansionPanelList(
        elevation: 1,
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        children: [
          ExpansionPanel(
            canTapOnHeader: true,
            backgroundColor: Colors.transparent,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/notification.svg', // Adjust the height as needed
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: const Text(
                      "Notification",
                      style: AppTypography.settingsViewTitle,
                    ),
                  ),
                ],
              );
            },
            body: Column(
              children: [
                SettingOnOffWidget(title: 'Pause all', iconPath: '', onTap: () {  }, isNotificationMenu: true,),
                SettingOnOffWidget(title: 'Recommendations', iconPath: '', onTap: () {  }, isNotificationMenu: true,),
                SettingOnOffWidget(title: 'Rewards update', iconPath: '', onTap: () {  }, isNotificationMenu: true,),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'This will not affect Payment reminders',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
            isExpanded: _isExpanded,
          ),
        ],
      ),
    );
  }
}