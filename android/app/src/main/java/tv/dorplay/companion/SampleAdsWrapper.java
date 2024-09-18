/*
 * Copyright 2015 Google, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package tv.dorplay.companion;

import android.annotation.SuppressLint;
import android.content.Context;
import android.os.Build;
import android.util.Log;
import android.view.ViewGroup;
import android.webkit.WebView;

import androidx.annotation.Nullable;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;

import com.google.ads.interactivemedia.v3.api.AdErrorEvent;
import com.google.ads.interactivemedia.v3.api.AdEvent;
import com.google.ads.interactivemedia.v3.api.AdsLoader;
import com.google.ads.interactivemedia.v3.api.AdsManagerLoadedEvent;
import com.google.ads.interactivemedia.v3.api.CuePoint;
import com.google.ads.interactivemedia.v3.api.ImaSdkFactory;
import com.google.ads.interactivemedia.v3.api.ImaSdkSettings;
import com.google.ads.interactivemedia.v3.api.StreamDisplayContainer;
import com.google.ads.interactivemedia.v3.api.StreamManager;
import com.google.ads.interactivemedia.v3.api.StreamRequest;
import com.google.ads.interactivemedia.v3.api.StreamRequest.StreamFormat;
import com.google.ads.interactivemedia.v3.api.player.VideoProgressUpdate;
import com.google.ads.interactivemedia.v3.api.player.VideoStreamPlayer;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;

/** This class adds ad-serving support to Sample HlsVideoPlayer */
@SuppressLint("UnsafeOptInUsageError")
/* @SuppressLint is needed for new media3 APIs. */
public class SampleAdsWrapper
    implements AdEvent.AdEventListener, AdErrorEvent.AdErrorListener, AdsLoader.AdsLoadedListener {

  // Live HLS stream asset key.
  private static final String TEST_HLS_ASSET_KEY = "c-rArva4ShKVIAkNfy6HUQ";

  // Live DASH stream asset key.
  private static final String TEST_DASH_ASSET_KEY = "PSzZMzAkSXCmlJOWDmRj8Q";

  // VOD HLS content source and video IDs.
  private static final String TEST_HLS_CONTENT_SOURCE_ID = "2548831";
  private static final String TEST_HLS_VIDEO_ID = "tears-of-steel";

  // VOD DASH content source and video IDs.
  private static final String TEST_DASH_CONTENT_SOURCE_ID = "2559737";
  private static final String TEST_DASH_VIDEO_ID = "tos-dash";

  private static final String PLAYER_TYPE = "DAISamplePlayer";

  private enum ContentType {
    LIVE_HLS,
    LIVE_DASH,
    VOD_HLS,
    VOD_DASH,
  }

  // Set CONTENT_TYPE to the associated enum for the stream type you would like to test.
  private static final ContentType CONTENT_TYPE = ContentType.VOD_HLS;

  /** Log interface, so we can output the log commands to the UI or similar. */
  public interface Logger {
    void log(String logMessage);
  }

  private final ImaSdkFactory sdkFactory;
  private AdsLoader adsLoader;
  private StreamDisplayContainer displayContainer;
  private StreamManager streamManager;
  private final List<VideoStreamPlayer.VideoStreamPlayerCallback> playerCallbacks;

  private final SampleVideoPlayer videoPlayer;
  private final Context context;
  private final ViewGroup adUiContainer;

  private String fallbackUrl;
  static public String streamId;
  private Logger logger;
  private Timer timer;


  String assetKeys;
  String devicesID;
  String seasonsID;
  String appName;
  String contentProvider;
  String showsID;
  String episodesID;
  String guid;

  /**
   * Creates a new SampleAdsWrapper that implements IMA direct-ad-insertion.
   *
   * @param context the app's context.
   * @param videoPlayer underlying HLS video player.
   * @param adUiContainer ViewGroup in which to display the ad's UI.
   */
  public SampleAdsWrapper(Context context, SampleVideoPlayer videoPlayer, ViewGroup adUiContainer,String get_devicesID, String get_seasonsID, String get_assetKeys, String get_appName, String get_contentProvider, String get_showsID, String get_episodesID,String get_guid) {
    this.videoPlayer = videoPlayer;
    this.context = context;
    this.adUiContainer = adUiContainer;
    sdkFactory = ImaSdkFactory.getInstance();
    playerCallbacks = new ArrayList<>();
    assetKeys = get_assetKeys;
    devicesID = get_devicesID;
    seasonsID = get_seasonsID;
    appName = get_appName;
    contentProvider = get_contentProvider;
    showsID = get_showsID;
    episodesID = get_episodesID;
    guid = get_guid;
    createAdsLoader();
  }

  private void enableWebViewDebugging() {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
      WebView.setWebContentsDebuggingEnabled(true);
    }
  }

  private void createAdsLoader() {
    ImaSdkSettings settings = sdkFactory.createImaSdkSettings();
    // Change any settings as necessary here.
    settings.setPlayerType(PLAYER_TYPE);
    enableWebViewDebugging();
    VideoStreamPlayer videoStreamPlayer = createVideoStreamPlayer();
    displayContainer = ImaSdkFactory.createStreamDisplayContainer(adUiContainer, videoStreamPlayer);
    videoPlayer.setSampleVideoPlayerCallback(
        new SampleVideoPlayer.SampleVideoPlayerCallback() {
          @Override
          public void onUserTextReceived(String userText) {
            for (VideoStreamPlayer.VideoStreamPlayerCallback callback : playerCallbacks) {
              callback.onUserTextReceived(userText);
            }
          }

          @Override
          public void onSeek(int windowIndex, long positionMs) {
            // See if we would seek past an ad, and if so, jump back to it.
            long newSeekPositionMs = positionMs;
            if (streamManager != null) {
              CuePoint prevCuePoint = streamManager.getPreviousCuePointForStreamTimeMs(positionMs);
              if (prevCuePoint != null && !prevCuePoint.isPlayed()) {
                newSeekPositionMs = prevCuePoint.getStartTimeMs();
              }
            }
            videoPlayer.seekTo(windowIndex, newSeekPositionMs);
          }

          @Override
          public void onContentComplete() {
            for (VideoStreamPlayer.VideoStreamPlayerCallback callback : playerCallbacks) {
              callback.onContentComplete();
            }
          }

          @Override
          public void onPause() {
            for (VideoStreamPlayer.VideoStreamPlayerCallback callback : playerCallbacks) {
              callback.onPause();
            }
          }

          @Override
          public void onResume() {
            for (VideoStreamPlayer.VideoStreamPlayerCallback callback : playerCallbacks) {
              callback.onResume();
            }
          }

          @Override
          public void onVolumeChanged(int percentage) {
            for (VideoStreamPlayer.VideoStreamPlayerCallback callback : playerCallbacks) {
              callback.onVolumeChanged(percentage);
            }
          }
        });
    adsLoader = sdkFactory.createAdsLoader(context, settings, displayContainer);
  }

  public void requestAndPlayAds() {
    adsLoader.addAdErrorListener(this);
    adsLoader.addAdsLoadedListener(this);
    adsLoader.requestStream(buildStreamRequest());
  }

  @Nullable
  private StreamRequest buildStreamRequest() {
    StreamRequest request;
    switch (CONTENT_TYPE) {
      case LIVE_HLS:
        // Live HLS stream request.
        return sdkFactory.createLiveStreamRequest(TEST_HLS_ASSET_KEY, null);
      case LIVE_DASH:
        // Live DASH stream request.
        return sdkFactory.createLiveStreamRequest(TEST_DASH_ASSET_KEY, null);
      case VOD_HLS:
        // VOD HLS request.
        request =
            sdkFactory.createVodStreamRequest(
                TEST_HLS_CONTENT_SOURCE_ID, TEST_HLS_VIDEO_ID, null); // apiKey
        request.setFormat(StreamFormat.HLS);
        return request;
      case VOD_DASH:
        // VOD DASH request.
        request =
            sdkFactory.createVodStreamRequest(
                TEST_DASH_CONTENT_SOURCE_ID, TEST_DASH_VIDEO_ID, null); // apiKey
        request.setFormat(StreamFormat.DASH);
        return request;
    }
    // Content type not selected.
    return null;
  }

  private VideoStreamPlayer createVideoStreamPlayer() {
    return new VideoStreamPlayer() {
      @Override
      public void loadUrl(String url, List<HashMap<String, String>> subtitles) {
        videoPlayer.setStreamUrl(assetKeys);
        streamId = streamManager.getStreamId();
        log("-----------------------getStreamId----------------------------");
        log(streamManager.getStreamId());
        log("---------------------------------------------------");
        videoPlayer.play();
        trackingAPI();
      }

      public void trackingAPI() {
        // Check if SampleAdsWrapper.streamId is not null
        if (SampleAdsWrapper.streamId != null) {
          // Call the method every second for the first 10 seconds
          timer = new Timer();
          timer.scheduleAtFixedRate(new TimerTask() {
            int tickCount = 1;

            @Override
            public void run() {
              if (tickCount <= 10) {
                String streamId = SampleAdsWrapper.streamId;

                // Call your method here
                Log.d("TrackingAPI", "timer 10 sec --- >>>> " + tickCount);
                String randomNumber = String.valueOf(Calendar.getInstance().getTimeInMillis());
                String url = "https://i.jsrdn.com/i/1.gif?" +
                        "dpname=" + "dorplay" +
                        "&r=" + randomNumber +/// A random number
                        "&e=vs" + tickCount +/// vplay, ff, vs1, vs2, etc.
                        "&u=" + devicesID +/// Device specific ID
                        "&i=" + guid +/// dai_session_id
                        "&v=" + guid +/// dai_asset_key
                        "&f=" + assetKeys +
                        "&m=" + appName + /// App Name
                        "&p=" + contentProvider +/// The "content_provider" value from the feed
                        "&show=" + showsID +///The show’s "id" element from the feed
                        "&ep=" + episodesID;

                trackingPixel(url);
                tickCount++;
              } else {
                // After 10 seconds, cancel the current timer
                timer.cancel();

                // Start a new timer to call the method every 60 seconds
                timer = new Timer();
                timer.scheduleAtFixedRate(new TimerTask() {
                  int minuteCount = 0;

                  @Override
                  public void run() {
                    // Call your method here
                    if(minuteCount != 0){
                      String streamId = SampleAdsWrapper.streamId;

                      Log.d("TrackingAPI", "after timer " + minuteCount + " min --- >>>> " + (minuteCount ) * 60);
                      String randomNumber = String.valueOf(Calendar.getInstance().getTimeInMillis());
                      String url = "https://i.jsrdn.com/i/1.gif?" +
                              "dpname=" + "dorplay" +
                              "&r=" + randomNumber +/// A random number
                              "&e=vs" + (minuteCount * 60) +/// vplay, ff, vs1, vs2, etc.
                              "&u=" + devicesID +/// Device specific ID
                              "&i=" + guid +/// dai_session_id
                              "&v=" + guid +/// dai_asset_key
                              "&f=" + assetKeys +
                              "&m=" + appName + /// App Name
                              "&p=" + contentProvider +/// The "content_provider" value from the feed
                              "&show=" + showsID +///The show’s "id" element from the feed
                              "&ep=" + episodesID;
                      trackingPixel(url);
                    }
                    minuteCount++;
                  }
                }, 0, 60 * 1000); // 60 seconds interval
              }
            }
          }, 0, 1000); // 1-second interval
        } else {
          // Log a message or handle the case when SampleAdsWrapper.streamId is null
          Log.d("TrackingAPI", "SampleAdsWrapper.streamId is null. Timer not started.");
          try {
            // Introduce a delay of 1 second
            Thread.sleep(1000);
          } catch (InterruptedException e) {
            e.printStackTrace();
          }
        }
      }

      private void trackingPixel(String url) {
        // RequestQueue initialized
        Log.d("trackingPixel", "Call URl --- >>>> " + url);

        RequestQueue mRequestQueue = Volley.newRequestQueue(context);

        // String Request initialized
        StringRequest mStringRequest = new StringRequest(Request.Method.GET, url,
                new Response.Listener<String>() {
                  public void onResponse(String response) {
                    Log.d("trackingPixel",response.toString());
                  }
                }, new Response.ErrorListener() {
          public void onErrorResponse(VolleyError error) {
            Log.d("trackingPixel onError","Error get here");
          }
        });
        Log.d("trackingPixel API CALL","mRequestQueue");
        mRequestQueue.add(mStringRequest);
      }



      @Override
      public void pause() {
        // Pause player.
        videoPlayer.pause();
      }

      @Override
      public void resume() {
        // Resume player.
        videoPlayer.play();
      }

      @Override
      public int getVolume() {
        // Make the video player play at the current device volume.
        return 100;
      }

      @Override
      public void addCallback(VideoStreamPlayerCallback videoStreamPlayerCallback) {
        playerCallbacks.add(videoStreamPlayerCallback);
      }

      @Override
      public void removeCallback(VideoStreamPlayerCallback videoStreamPlayerCallback) {
        playerCallbacks.remove(videoStreamPlayerCallback);
      }

      @Override
      public void onAdBreakStarted() {
        // Disable player controls.
        videoPlayer.enableControls(false);
        log("Ad Break Started\n");
      }

      @Override
      public void onAdBreakEnded() {
        // Re-enable player controls.
        if (videoPlayer != null) {
          videoPlayer.enableControls(true);
        }
        log("Ad Break Ended\n");
      }

      @Override
      public void onAdPeriodStarted() {
        log("Ad Period Started\n");
      }

      @Override
      public void onAdPeriodEnded() {
        log("Ad Period Ended\n");
      }

      @Override
      public void seek(long timeMs) {
        // An ad was skipped. Skip to the content time.
        videoPlayer.seekTo(timeMs);
        log("seek");
      }

      @Override
      public VideoProgressUpdate getContentProgress() {
        return new VideoProgressUpdate(
            videoPlayer.getCurrentPositionMs(), videoPlayer.getDuration());
      }
    };
  }

  /** AdErrorListener implementation */
  @Override
  public void onAdError(AdErrorEvent event) {
    log(String.format("Error: %s\n", event.getError().getMessage()));
    // play fallback URL.
    log("Playing fallback Url\n");
    videoPlayer.setStreamUrl(fallbackUrl);
    videoPlayer.enableControls(true);
    videoPlayer.play();
  }

  /** AdEventListener implementation */
  @Override
  public void onAdEvent(AdEvent event) {
    switch (event.getType()) {
      case AD_PROGRESS:
        // Do nothing or else log will be filled by these messages.
        break;
      default:
        log(String.format("Event: %s\n", event.getType()));
        break;
    }
  }

  /** AdsLoadedListener implementation */
  @Override
  public void onAdsManagerLoaded(AdsManagerLoadedEvent event) {
    streamManager = event.getStreamManager();
    streamManager.addAdErrorListener(this);
    streamManager.addAdEventListener(this);
    streamManager.init();
  }

  /** Sets fallback URL in case ads stream fails. */
  void setFallbackUrl(String url) {
    fallbackUrl = url;
  }

  public  String getStreamID() {
    return streamId;
  }

  /** Sets logger for displaying events to screen. Optional. */
  void setLogger(Logger logger) {
    this.logger = logger;
  }

  private void log(String message) {
    if (logger != null) {
      logger.log(message);
    }
  }
}
