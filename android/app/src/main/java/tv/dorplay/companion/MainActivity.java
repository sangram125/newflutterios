package tv.dorplay.companion;

import static androidx.media3.common.C.CONTENT_TYPE_HLS;

import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.content.res.Configuration;
import android.net.Uri;
import android.os.Bundle;
import android.text.method.ScrollingMovementMethod;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageButton;
import android.widget.TextView;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import android.content.ActivityNotFoundException;

import java.util.Map;
import java.util.Timer;

import androidx.annotation.Nullable;
import androidx.media3.ui.PlayerView;
import io.flutter.embedding.android.FlutterActivity;


public class MainActivity extends FlutterActivity {
    private static final String DEEPLINKS_CHANNEL = "tv.dorplay.companion/deeplinks";
    private MethodChannel channel;

    private static final String DEFAULT_STREAM_URL =
            "https://stream-us-east-1.getpublica.com/playlist.m3u8?network_id=1962&live=1&avod=1&app_bundle=__APP_BUNDLE__&did=__DEVICE_ID__&app_category=__APP_CATEGORY__&app_domain=__APP_DOMAIN__&app_name=dorplay&app_store_url=__STORE_URL__&app_version=__APP_VERSION__&hls_marker=1&cb=__CACHE_BUSTER__&ip=__CLIENT_IP__&ua=__USER_AGENT__&player_height=1080&player_width=1920&is_lat=__LIMIT_AD_TRACKING__&ads.islive=1&ads.streamtype=live";
    protected SampleVideoPlayer sampleVideoPlayer;
    protected ImageButton playButton;

    private boolean contentHasStarted = false;

    String assetKeys;
    String devicesID;
    String seasonsID;
    String appName;
    String contentProvider;
    String showsID;
    String episodesID;
    String guid;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        channel = new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), "flutter_with_evoplayer");
        channel.setMethodCallHandler((call, result) -> {
            switch (call.method) {
                case "initializePlayer":
//                    getData();
                    setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);
                    assetKeys = call.argument("daiAssetKey").toString(); // Get the asset key from Flutter
                    // Get the tracking data from Flutter
                    devicesID = call.argument("devicesID").toString();
                    seasonsID = call.argument("seasonsID").toString();
                    appName = call.argument("appName").toString();
                    contentProvider = call.argument("contentProvider").toString();
                    showsID = call.argument("showsID").toString();
                    episodesID = call.argument("episodesID").toString();
                    guid = call.argument("guid").toString();
                    setContentView(R.layout.activity_my);
                    View rootView = findViewById(R.id.videoLayout);
                    sampleVideoPlayer =
                            new SampleVideoPlayer(
                                    rootView.getContext(), (PlayerView) rootView.findViewById(R.id.playerView));
                    sampleVideoPlayer.enableControls(false);
                    playButton = (ImageButton) rootView.findViewById(R.id.playButton);
                    final SampleAdsWrapper sampleAdsWrapper =
                            new SampleAdsWrapper(
                                    this, sampleVideoPlayer, (ViewGroup) rootView.findViewById(R.id.adUiContainer),devicesID,seasonsID,assetKeys,appName,contentProvider,showsID,episodesID,guid);
                    sampleAdsWrapper.setFallbackUrl(DEFAULT_STREAM_URL);

                    // Set up play button listener to play video then hide play button.
                    playButton.setOnClickListener(
                            new View.OnClickListener() {
                                @Override
                                public void onClick(View view) {
                                    if (contentHasStarted) {
                                        sampleVideoPlayer.play();
                                    } else {
                                        contentHasStarted = true;
                                        sampleVideoPlayer.enableControls(true);
                                        sampleAdsWrapper.requestAndPlayAds();
                                    }
                                    playButton.setVisibility(View.GONE);
                                }
                            });
                    orientVideoDescription(getResources().getConfiguration().orientation);
                    break;
                case "onAdCompleted":
                    break;
                default:
                    result.notImplemented();
                    break;
            }
        });
    }


    @Override
    public void onConfigurationChanged(Configuration configuration) {
        super.onConfigurationChanged(configuration);
        orientVideoDescription(configuration.orientation);
    }

    private void orientVideoDescription(int orientation) {
    }


    private boolean isInFlutterSection() {
        // Add your logic to determine if you are in the Flutter section
        // For example, you can check a flag or a specific condition
        // Return true if in the Flutter section, false otherwise
        return false;
    }

    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(
                flutterEngine.getDartExecutor().getBinaryMessenger(),
                DEEPLINKS_CHANNEL
        ).setMethodCallHandler((call, result) -> {
            switch (call.method) {
                case "viewDeeplink":
                    viewDeeplink(call, result);
                    break;
                default:
                    result.notImplemented();
                    break;
            }
        });
    }

    @SuppressWarnings("unchecked")
    private void viewDeeplink(MethodCall call, MethodChannel.Result result) {
        if (call.arguments instanceof Map) {
            Map<String, String> args = (Map<String, String>) call.arguments;
            String deeplinkString = args.get("deeplink");
            String packageName = args.get("packageName");

            if (deeplinkString != null && packageName != null) {
                Uri deeplink = Uri.parse(deeplinkString);
                String error = triggerDeeplink(deeplink, packageName);

                if (error != null) {
                    result.error("Deeplink Error", error, null);
                } else {
                    result.success("");
                }
            } else {
                result.error("Invalid arguments", "Missing deeplink or packageName", null);
            }
        } else {
            result.error("Invalid arguments", "Expected a Map for call arguments", null);
        }
    }


    private String triggerDeeplink(Uri deeplink, String packageName) {
        Intent intent = new Intent(Intent.ACTION_VIEW, deeplink);
        intent.setPackage(packageName);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TOP);

        try {
            startActivity(intent);
        } catch (ActivityNotFoundException anfx) {
            return redirectToPlayStore(packageName);
        } catch (Exception e) {
            Log.e("viewDeeplink", e.toString());
            return "Error launching deeplink";
        }

        return null;
    }

    private String redirectToPlayStore(String packageName) {
        Intent storeIntent = new Intent(Intent.ACTION_VIEW,
                Uri.parse("https://play.google.com/store/apps/details?id=" + packageName));
        storeIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);

        try {
            startActivity(storeIntent);
        } catch (Exception e) {
            return "Failed to open Play Store listing";
        }

        return "Redirecting to Play Store";
    }

}
