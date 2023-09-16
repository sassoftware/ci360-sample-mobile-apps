import React, { useEffect } from 'react';
import { View, NativeEventEmitter } from 'react-native';
import { InterstitialAdView, AdDelegateEvent, Constants } from 'mobile-sdk-react-native';

let iOSMessagingEvent: NativeEventEmitter;
 if (Platform.OS === 'ios') {
   iOSMessagingEvent = new NativeEventEmitter(AdDelegateEvent);
 }


const addInterstitialAdViewExample: React.FC = () => {
	useEffect(() => {
      if (Platform.OS === 'ios') {
        const adLoadedListener = iOSMessagingEvent.addListener(Constants.AD_LOADED, (event: Event) => {
          if (event === Constants.TYPE_INTERSTITIAL_AD) {
            console.log('Interstitial Ad view is loaded.');
          }
        });

        const adDefaultLoadedListener = iOSMessagingEvent.addListener(Constants.AD_DEFAULT_LOADED, (event: Event) => {
          if (event === Constants.TYPE_INTERSTITIAL_AD) {
            console.log('Interstitial Ad view returned default content.');
          }
        });

        return () => {
          adLoadedListener.remove();
          adDefaultLoadedListener.remove();
        };
      }
    }, []);


   return (
     <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
        <InterstitialAdView
            spotId="snzrle_app_interstitial" //the mobile spot id defined in your tenant
        />
        <Text>Page to load Interstitial Spot.</Text>
     </View>
   );
};

export default addInterstitialAdViewExample;