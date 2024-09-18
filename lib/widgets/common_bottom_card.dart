import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../assets.dart';

class CustomBottomCard extends StatefulWidget {
  final List<String> items;

  const CustomBottomCard({
    super.key,
    required this.items,
  });

  @override
  _CustomBottomCardState createState() => _CustomBottomCardState();
}

class _CustomBottomCardState extends State<CustomBottomCard> {
  String? selectedDevice; // To store selected "TV" or "Mobile"
  String? selectedOTT;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Choose Device".toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          _buildDeviceOption("Mobile"),
          const SizedBox(height: 10),
          _buildDeviceOption("TV"),
          const SizedBox(height: 15),
          Text(
            "Choose OTT".toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: ListView.builder(
              itemCount: widget.items.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return _buildOTTItem(widget.items[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceOption(String deviceName) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDevice = deviceName;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            width: 1,
            color: const Color(0xFF666666),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                image: const DecorationImage(
                  image: NetworkImage("https://via.placeholder.com/36x36"),
                  fit: BoxFit.fill,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(200),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                deviceName,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFFE5E5E5),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 10),
            if (selectedDevice == deviceName)
              SvgPicture.asset(Assets.assets_icons_tick_arrow_svg)
          ],
        ),
      ),
    );
  }

  Widget _buildOTTItem(String itemName) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOTT = itemName;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            width: 1,
            color: const Color(0xFF666666),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                image: const DecorationImage(
                  image: NetworkImage("https://via.placeholder.com/36x36"),
                  fit: BoxFit.fill,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(200),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                itemName,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFFE5E5E5),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 10),
            if (selectedOTT == itemName)
              SvgPicture.asset(Assets.assets_icons_tick_arrow_svg)
          ],
        ),
      ),
    );
  }
}

