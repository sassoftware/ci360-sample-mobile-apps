import * as React from 'react';
import { StyleSheet,  View, ScrollView, NativeEventEmitter, DeviceEventEmitter, Platform, } from 'react-native';
import Toast from 'react-native-simple-toast';
import { InlineAdView, InterstitialAdView, AdDelegateEvent, Constants } from 'mobile-sdk-react-native';
import CustomButton from '../components/CustomButton';

let iOSMessagingEvent: NativeEventEmitter;
if (Platform.OS === 'ios') {
  iOSMessagingEvent = new NativeEventEmitter(AdDelegateEvent);
}

export default function SpotsScreen() {
  const [showInterstitial, setShowInterstitial] = React.useState(false);


  React.useEffect (() => {
    if (Platform.OS === 'ios') {
      iOSMessagingEvent.addListener(Constants.AD_LOADED, (event: Event) => {
        if (event === Constants.TYPE_INTERSTITIAL_AD) {
          Toast.show('Interstitial Ad view is loaded', Toast.SHORT);
        } else if (event === Constants.TYPE_INLINE_AD) {
          Toast.show('Inline Ad view is loaded', Toast.SHORT);
        }
      });
      iOSMessagingEvent.addListener(Constants.AD_CLOSED, (event: Event) => {
        console.log('Ad closed');
        console.log(event);
        if (event === Constants.TYPE_INTERSTITIAL_AD) {
          Toast.show('Interstitial Ad view is closed by the user', Toast.SHORT);
        } else if (event === Constants.TYPE_INLINE_AD) {
          Toast.show('Inline Ad view is closed by the user', Toast.SHORT);
        }
        setShowInterstitial(false);
      });
    } else if (Platform.OS == 'android') {
      DeviceEventEmitter.addListener('onAdLoaded', (event: Event) => {
        if (event === Constants.TYPE_INTERSTITIAL_AD) {
          Toast.show('Interstitial Ad view is loaded', Toast.SHORT);
        } else if (event === Constants.TYPE_INLINE_AD) {
          Toast.show('Inline Ad view is loaded', Toast.SHORT);
        }
      });
      DeviceEventEmitter.addListener('onAdClosed', (event: Event) => {
        if (event === Constants.TYPE_INTERSTITIAL_AD) {
          Toast.show('Interstitial Ad view is closed by the user', Toast.SHORT);
        } else if (event === Constants.TYPE_INLINE_AD) {
          Toast.show('Inline Ad view is closed by the user', Toast.SHORT);
        }
        setShowInterstitial(false);
      });
    }
    return () => {
      DeviceEventEmitter.removeAllListeners();
      if (Platform.OS === 'ios') {
        iOSMessagingEvent.removeAllListeners(AdDelegateEvent);
      }
    }
  }, []);

    return (
      <ScrollView>
        <View style={styles.container}>
          <InlineAdView  spotId='snzrle_app_spot' style={styles.inlineView} />
          <CustomButton title='Show Interstitial Ad' onPress={() => {setShowInterstitial(true)}} width={{width: 200}} />
          {showInterstitial && <InterstitialAdView spotId='snzrle_app_interstitial'  />}

        </View>
      </ScrollView>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        alignItems: 'center',
        justifyContent: 'space-around',

    },
    inlineView: {
      height: 400,
      width: 300,
      marginBottom: 50,
    },
    button: {
      height: 40,
      width: 200,
      borderRadius: 10,
      borderWidth: 2,
      borderColor: 'gray',
      alignItems: 'center',
      justifyContent: 'center',
      backgroundColor: '#14AAF5',
      marginTop: 100
    },
    buttonText: {
      color: 'white',
    }
})
