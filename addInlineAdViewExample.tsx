import React, { useEffect } from 'react';
import { View, NativeEventEmitter } from 'react-native';
import { InlineAdView, AdDelegateEvent, Constants } from 'mobile-sdk-react-native';

let iOSMessagingEvent: NativeEventEmitter;
 if (Platform.OS === 'ios') {
   iOSMessagingEvent = new NativeEventEmitter(AdDelegateEvent);
 }


const addInlineAdViewExample: React.FC = () => {
	 useEffect(() => {
	   if (Platform.OS === 'ios') {
	     const adLoadedListener = iOSMessagingEvent.addListener(Constants.AD_LOADED, (event: Event) => {
	       if (event === Constants.TYPE_INLINE_AD) {
	         console.log('Inline Ad view is loaded.');
	       }
	     });

	     const adDefaultLoadedListener = iOSMessagingEvent.addListener(Constants.AD_DEFAULT_LOADED, (event: Event) => {
	       if (event === Constants.TYPE_INLINE_AD) {
	         console.log('Inline Ad view returned default content.');
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
	     <InlineAdView
	         spotId="snzrle_app_spot" //the mobile spot id defined in your tenant
	         style={{ height: 250, width:300, margin: 25}}
	     />
	  </View>
	);

};

export default addInlineAdViewExample;