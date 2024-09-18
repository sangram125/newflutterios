import 'package:dio/dio.dart';
import 'package:dor_companion/remote_buttons_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/api/sensy_api.dart';
import '../../data/models/models.dart';
import '../../injection/injection.dart';
import '../../utils.dart';
import '../../widgets/appbar.dart';
import '../widgets/dpad_view.dart';

typedef ButtonUpCallback = void Function(RemoteButton button);

const buttonSize = 64.0;

enum RemoteButton {
  power,
  voice,
  mute,
  library,
  search,
  settings,
  up,
  right,
  down,
  left,
  ok,
  volUp,
  volDown,
  chUp,
  chDown,
  back,
  home,
  apps,
  prime,
  hotstar,
  sonyliv,
  youtube,
  lionsgate,
  netflix,
  zee5,
  sunnxt,
}

class RemoteView extends StatefulWidget {
  final String deviceId;

  const RemoteView({super.key, required this.deviceId});

  @override
  RemoteViewState createState() => RemoteViewState();
}

class RemoteViewState extends State<RemoteView> {
  late ButtonUpCallback callback;

  @override
  void initState() {
    super.initState();
    callback = (button) {
      HapticFeedback.lightImpact();

      final ChatAction chatAction;
      switch (button) {
        case RemoteButton.power:
          if (kDebugMode) {
            print("Power onTapDown");
          }
          chatAction = getKeyPressAction("26");
          break;
        case RemoteButton.voice:
          if (kDebugMode) {
            print("Voice search onTapDown");
          }
          chatAction = getIntentAction("-1");
          break;
        case RemoteButton.mute:
          if (kDebugMode) {
            print("Mute onTapDown");
          }
          chatAction = getRemoteKeyAction("VOL MUTE");
          break;
        case RemoteButton.library:
          if (kDebugMode) {
            print("Power onTapDown");
          }
          chatAction = getIntentAction("intent:#Intent;"
              "action=co.sensara.appsense.intent.action.PLAYLISTS;"
              "category=android.intent.category.DEFAULT;"
              "end");
          break;
        case RemoteButton.search:
          if (kDebugMode) {
            print("Voice search onTapDown");
          }
          chatAction = getIntentAction("intent:#Intent;"
              "action=co.sensara.appsense.intent.action.TEXT_SEARCH;"
              "category=android.intent.category.DEFAULT;"
              "end");
          break;
        case RemoteButton.settings:
          if (kDebugMode) {
            print("Mute onTapDown");
          }
          chatAction = getLaunchScreenAction("SETTINGS");
          break;
        case RemoteButton.up:
          if (kDebugMode) {
            print("DPad up onTapDown");
          }
          chatAction = getKeyPressAction("19");
          break;
        case RemoteButton.down:
          if (kDebugMode) {
            print("DPad down onTapDown");
          }
          chatAction = getKeyPressAction("20");
          break;
        case RemoteButton.left:
          if (kDebugMode) {
            print("DPad left onTapDown");
          }
          chatAction = getKeyPressAction("21");
          break;
        case RemoteButton.right:
          if (kDebugMode) {
            print("DPad right onTapDown");
          }
          chatAction = getKeyPressAction("22");
          break;
        case RemoteButton.ok:
          if (kDebugMode) {
            print("OK onTapDown");
          }
          chatAction = getKeyPressAction("23");
          break;
        case RemoteButton.volUp:
          if (kDebugMode) {
            print("Vol up onTapDown");
          }
          chatAction = getRemoteKeyAction("VOL UP");
          break;
        case RemoteButton.volDown:
          if (kDebugMode) {
            print("Vol down onTapDown");
          }
          chatAction = getRemoteKeyAction("VOL DOWN");
          break;
        case RemoteButton.chUp:
          if (kDebugMode) {
            print("Ch up onTapDown");
          }
          chatAction = getIntentAction("-1");
          break;
        case RemoteButton.chDown:
          if (kDebugMode) {
            print("Ch down onTapDown");
          }
          chatAction = getIntentAction("-1");
          break;
        case RemoteButton.back:
          if (kDebugMode) {
            print("Back onTapDown");
          }
          chatAction = getKeyPressAction("4");
          break;
        case RemoteButton.home:
          if (kDebugMode) {
            print("Home onTapDown");
          }
          chatAction = getIntentAction("intent:#Intent;"
              "action=android.intent.action.MAIN;"
              "category=android.intent.category.HOME;"
              "end");
          break;
        case RemoteButton.apps:
          if (kDebugMode) {
            print("Apps onTapDown");
          }
          chatAction = getIntentAction("intent:#Intent;"
              "action=android.intent.action.ALL_APPS;"
              "category=android.intent.category.DEFAULT;"
              "end");
          break;
        case RemoteButton.prime:
          if (kDebugMode) {
            print("Prime onTapDown");
          }
          chatAction = getLaunchAppAction("com.amazon.amazonvideo.livingroom");
          break;
        case RemoteButton.hotstar:
          if (kDebugMode) {
            print("Hotstar onTapDown");
          }
          chatAction = getLaunchAppAction("in.startv.hotstar.dplus.tv");
          break;
        case RemoteButton.sonyliv:
          if (kDebugMode) {
            print("SonyLiv onTapDown");
          }
          chatAction = getLaunchAppAction("com.sonyliv");
          break;
        case RemoteButton.youtube:
          if (kDebugMode) {
            print("Youtube onTapDown");
          }
          chatAction = getLaunchAppAction("com.google.android.youtube.tv");
          break;
        case RemoteButton.lionsgate:
          if (kDebugMode) {
            print("Lionsgate onTapDown");
          }
          chatAction = getLaunchAppAction("com.lionsgateplay.videoapp");
          break;
        case RemoteButton.netflix:
          if (kDebugMode) {
            print("Netflix onTapDown");
          }
          chatAction = getLaunchAppAction("com.netflix.ninja");
          break;
        case RemoteButton.zee5:
          if (kDebugMode) {
            print("Zee5 onTapDown");
          }
          chatAction = getLaunchAppAction("com.graymatrix.did");
          break;
        case RemoteButton.sunnxt:
          if (kDebugMode) {
            print("Sunnxt onTapDown");
          }
          chatAction = getLaunchAppAction("com.suntv.sunnxt");
          break;
        default:
          return;
      }

      getIt<SensyApi>()
          .forwardToTvDevice(widget.deviceId, chatAction)
          .catchError((errorObj, stackTrace) {
        if (kDebugMode) {
          print("$errorObj");
        }
        switch (errorObj.runtimeType) {
          case DioException:
            final response = (errorObj as DioException).response;
            showVanillaToast("Failed to forward keypress to device:"
                " ${response?.statusCode}");
        }
      });
    };
  }

  getKeyPressAction(String actionId) {
    return ChatAction(
      actionType: "SEND_KEYCODE",
      actionID: actionId,
      actionTitle: "Send keycode",
      response: "",
    );
  }

  getIntentAction(String intentAction) {
    return ChatAction(
      actionType: "TRIGGER_INTENT",
      actionID: intentAction,
      actionTitle: "Launch intent",
      response: "",
    );
  }

  getLaunchAppAction(String packageName) {
    return ChatAction(
      actionType: "LAUNCH_APP",
      actionID: packageName,
      actionTitle: "Launch app",
      response: "",
    );
  }

  getLaunchScreenAction(String screen) {
    return ChatAction(
      actionType: "LAUNCH_SCREEN",
      actionID: screen,
      actionTitle: "Launch screen",
      response: "",
    );
  }

  getRemoteKeyAction(String action) {
    return ChatAction(
      actionType: "SEND_REMOTE_KEY",
      actionID: action,
      actionTitle: "Remote key",
      response: "",
    );
  }

  @override
  Widget build(BuildContext context) {
    const space = 32.0;

    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.0,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(40),
            color: Colors.white.withOpacity(0.05),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(height: space),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  button(RemoteButtons.vector, RemoteButton.power),
                  empty(),
                  //button(Icons.keyboard_voice_outlined, RemoteButton.voice),
                  button(RemoteButtons.volume_mute, RemoteButton.mute),
                ],
              ),
              const SizedBox(height: space),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  button(RemoteButtons.bookmark, RemoteButton.library),
                  button(RemoteButtons.search, RemoteButton.search),
                  button(RemoteButtons.settings, RemoteButton.settings),
                ],
              ),
              const SizedBox(height: space),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  volume(),
                  DPadView(callback: callback),
                  channel(),
                ],
              ),
              const SizedBox(height: space),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  button(RemoteButtons.back_arrow, RemoteButton.back),
                  empty(),
                  button(RemoteButtons.home, RemoteButton.home),
                ],
              ),
              const SizedBox(height: space),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  app("prime.jpg", RemoteButton.prime),
                  app("hotstar.jpg", RemoteButton.hotstar),
                  app("sonyliv.webp", RemoteButton.sonyliv),
                  //app("youtube.jpg", RemoteButton.youtube),
                ],
              ),
              const SizedBox(height: space),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  app("lionsgate.png", RemoteButton.lionsgate),
                  app("netflix.png", RemoteButton.netflix),
                  app("zee5.jpg", RemoteButton.zee5),
                  //app("sunnxt.png", RemoteButton.sunnxt),
                ],
              ),
              const SizedBox(height: space),
            ],
          ),
        ),
      ),
    );
  }

  Widget button(IconData iconData, RemoteButton button,
      [Color backgroundColor = const Color(0x00555555)]) {
    return Container(
      height: 62,
      width: 62,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF).withOpacity(0.2),
        shape: BoxShape.rectangle,
        border: Border.all(
          color: iconData.codePoint == 0xe81b ? const Color(0xFFF44236) : Colors.white.withOpacity(0.2),
          width: 1.0,
          style: BorderStyle.solid,
        ),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 8.0,
            blurRadius: 8.0,
          )
        ],
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(18.0)),
        child: Material(
          color: backgroundColor,
          child: InkResponse(
            containedInkWell: false,
            highlightShape: BoxShape.rectangle,
            highlightColor: const Color(0x66444444),
            splashColor: const Color(0x00FFFFFF),
            child: SizedBox(
              height: buttonSize,
              width: buttonSize,
              child: Icon(
                iconData,
                color: iconData.codePoint == 0xe81b ? const Color(0xFFF44236) : const Color(0xEEFFFFFF),
              ),
            ),
            onTapDown: (details) {
              callback(button);
            },
          ),
        ),
      ),
    );
  }

  Widget empty() {
    return const SizedBox(
      height: buttonSize,
      width: buttonSize,
    );
  }

  ClipRRect app(String logo, RemoteButton app) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(20.0)),
      child: Material(
        child: Ink.image(
          image: AssetImage("assets/images/app_logos/$logo"),
          fit: BoxFit.contain,
          height: buttonSize,
          width: buttonSize,
          child: InkWell(
            highlightColor: const Color(0x66444444),
            splashColor: const Color(0x00FFFFFF),
            onTapDown: (details) {
              callback(app);
            },
          ),
        ),
      ),
    );
  }

  Container channel() {
    return Container(
      height: 150,
      width: 58,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: const Color(0xFFFFFFFF).withOpacity(0.2),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1.0,
          style: BorderStyle.solid,
        ),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 8.0,
            blurRadius: 8.0,
          )
        ],
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            child: Material(
              color: const Color(0x00FFFFFF),
              child: InkResponse(
                containedInkWell: false,
                highlightShape: BoxShape.rectangle,
                highlightColor: const Color(0xFF444444),
                splashColor: const Color(0x00FFFFFF),
                child: const SizedBox(
                  height: buttonSize,
                  width: buttonSize,
                  child: Icon(
                    size: 18.2,
                    RemoteButtons.up_arrow,
                    color: Color(0xEEFFFFFF),
                  ),
                ),
                onTapDown: (details) {
                  callback(RemoteButton.chUp);
                },
              ),
            ),
          ),
          const Text(
            'CH',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xEEFFFFFF),
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
            child: Material(
              color: const Color(0x00FFFFFF),
              child: InkResponse(
                containedInkWell: false,
                highlightShape: BoxShape.rectangle,
                highlightColor: const Color(0xFF444444),
                splashColor: const Color(0x00FFFFFF),
                child: const SizedBox(
                  height: buttonSize,
                  width: buttonSize,
                  child: Icon(
                    size: 18.2,
                    RemoteButtons.down_arrow,
                    color: Color(0xEEFFFFFF),
                  ),
                ),
                onTapDown: (details) {
                  callback(RemoteButton.chDown);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container volume() {
    return Container(
      height: 150,
      width: 58,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: const Color(0xFFFFFFFF).withOpacity(0.2),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1.0,
          style: BorderStyle.solid,
        ),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 8.0,
            blurRadius: 8.0,
          )
        ],
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            child: Material(
              color: const Color(0x00FFFFFF),
              child: InkResponse(
                containedInkWell: true,
                highlightShape: BoxShape.rectangle,
                highlightColor: const Color(0xFF444444),
                splashColor: const Color(0x00FFFFFF),
                child: const SizedBox(
                  height: buttonSize,
                  width: buttonSize,
                  child: Icon(
                    RemoteButtons.plus,
                    color: Color(0xEEFFFFFF),
                  ),
                ),
                onTapDown: (details) {
                  callback(RemoteButton.volUp);
                },
              ),
            ),
          ),
          const Text(
            'VOL',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xEEFFFFFF),
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
            child: Material(
              color: const Color(0x00FFFFFF),
              child: InkResponse(
                containedInkWell: true,
                highlightShape: BoxShape.rectangle,
                highlightColor: const Color(0xFF444444),
                splashColor: const Color(0x00FFFFFF),
                child: const SizedBox(
                  height: buttonSize,
                  width: buttonSize,
                  child: Icon(
                    RemoteButtons.minus,
                    color: Color(0xEEFFFFFF),
                  ),
                ),
                onTapDown: (details) {
                  callback(RemoteButton.volDown);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
