import React, { useEffect } from "react";
import {
  InterstitialAdView,
  AdDelegateEvent,
  Constants,
} from "mobile-sdk-react-native";
import {
  View,
  DeviceEventEmitter,
  NativeEventEmitter,
  Platform,
} from "react-native";
import Toast from "react-native-simple-toast";

const addInterstitialAdViewExample: React.FC = () => {
  useEffect(() => {
    if (Platform.OS == "android") {
      DeviceEventEmitter.addListener("onAdLoaded", (event: Event) => {
        if (event === Constants.TYPE_INTERSTITIAL_AD) {
          Toast.show("Interstitial Ad view is loaded", Toast.SHORT);
        } else if (event === Constants.TYPE_INLINE_AD) {
          Toast.show("Inline Ad view is loaded", Toast.SHORT);
        }
      });
      DeviceEventEmitter.addListener("onAdClosed", (event: Event) => {
        if (event === Constants.TYPE_INTERSTITIAL_AD) {
          Toast.show("Interstitial Ad view is closed by the user", Toast.SHORT);
        } else if (event === Constants.TYPE_INLINE_AD) {
          Toast.show("Inline Ad view is closed by the user", Toast.SHORT);
        }
      });
    }
  }, []);

  return (
    <View style={{ flex: 1, justifyContent: "center", alignItems: "center" }}>
      <InterstitialAdView
        spotId="snzrle_app_interstitial" //the mobile spot id defined in your tenant
      />
      <Text>Page to load Interstitial Spot.</Text>
    </View>
  );
};

export default addInterstitialAdViewExample;
