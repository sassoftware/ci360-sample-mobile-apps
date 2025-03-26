import React, { useState, useEffect } from 'react';
import {
  StyleSheet,
  View,
  ScrollView,
  NativeEventEmitter,
  DeviceEventEmitter,
  Platform,
  Text,
} from 'react-native';
import Toast from 'react-native-simple-toast';
import Icon from 'react-native-vector-icons/Ionicons';
import * as MobileSdk from 'mobile-sdk-react-native';
import {
  InlineAdView,
  InterstitialAdView,
  AdDelegateEvent,
  Constants,
} from 'mobile-sdk-react-native';
import CustomButton from '../components/CustomButton';

interface ContentScreenProps {}

const ContentScreen: React.FC<ContentScreenProps> = () => {
  const [showInterstitial, setShowInterstitial] = useState<boolean>(false);
  const [inlineViewNotVisible, setInlineViewNotVisible] =
    useState<boolean>(false);
  const inline_spotId = 'gp_inlineAd';
  const interstitial_spotId = 'gp_interstitialAd';

  let iOSMessagingEvent: NativeEventEmitter | undefined;
  if (Platform.OS === 'ios') {
    iOSMessagingEvent = new NativeEventEmitter(AdDelegateEvent);
  }

  useEffect(() => {
    if (Platform.OS === 'ios' && iOSMessagingEvent) {
      iOSMessagingEvent.addListener(
        Constants.AD_LOADED,
        (obj: { [key: string]: string }) => {
          const event = obj['eventType'];
          if (event === Constants.TYPE_INTERSTITIAL_AD) {
            Toast.show('Interstitial Ad view is loaded', Toast.SHORT);
          } else if (event === Constants.TYPE_INLINE_AD) {
            Toast.show('Inline Ad view is loaded', Toast.SHORT);
            setInlineViewNotVisible(false);
          }
        }
      );
      iOSMessagingEvent.addListener(
        Constants.AD_DEFAULT_LOADED,
        (obj: { [key: string]: string }) => {
          const event = obj['eventType'];
          if (event === Constants.TYPE_INTERSTITIAL_AD) {
            Toast.show('Interstitial Ad default view is loaded', Toast.SHORT);
          } else if (event === Constants.TYPE_INLINE_AD) {
            Toast.show('Inline Ad default view is loaded', Toast.SHORT);
            setInlineViewNotVisible(true);
          }
        }
      );
      iOSMessagingEvent.addListener(Constants.AD_CLOSED, (event: string) => {
        console.log('Ad closed');
        console.log(event);
        if (event === Constants.TYPE_INTERSTITIAL_AD) {
          Toast.show('Interstitial Ad view is closed by the user', Toast.SHORT);
        } else if (event === Constants.TYPE_INLINE_AD) {
          Toast.show('Inline Ad view is closed by the user', Toast.SHORT);
        }
        setShowInterstitial(false);
      });
    } else if (Platform.OS === 'android') {
      DeviceEventEmitter.addListener(
        Constants.AD_LOADED,
        (obj: { [key: string]: string }) => {
          const event = obj['eventType'];
          if (event === Constants.TYPE_INTERSTITIAL_AD) {
            Toast.show('Interstitial Ad view is loaded', Toast.SHORT);
          } else if (event === Constants.TYPE_INLINE_AD) {
            Toast.show('Inline Ad view is loaded', Toast.SHORT);
            setInlineViewNotVisible(false);
          }
        }
      );
      DeviceEventEmitter.addListener(
        Constants.AD_DEFAULT_LOADED,
        (obj: { [key: string]: string }) => {
          const event = obj['eventType'];
          if (event === Constants.TYPE_INTERSTITIAL_AD) {
            Toast.show('Interstitial Ad default view is loaded', Toast.SHORT);
          } else if (event === Constants.TYPE_INLINE_AD) {
            Toast.show('Inline Ad default view is loaded', Toast.SHORT);
            setInlineViewNotVisible(true);
          }
        }
      );
      DeviceEventEmitter.addListener(Constants.AD_CLOSED, (event: string) => {
        if (event === Constants.TYPE_INTERSTITIAL_AD) {
          Toast.show('Interstitial Ad view is closed by the user', Toast.SHORT);
        } else if (event === Constants.TYPE_INLINE_AD) {
          Toast.show('Inline Ad view is closed by the user', Toast.SHORT);
        }
        setShowInterstitial(false);
      });
    }

    return () => {
      if (Platform.OS === 'android') {
        DeviceEventEmitter.removeAllListeners(Constants.AD_LOADED);
        DeviceEventEmitter.removeAllListeners(Constants.AD_DEFAULT_LOADED);
        DeviceEventEmitter.removeAllListeners(Constants.AD_CLOSED);
      }
      if (Platform.OS === 'ios' && iOSMessagingEvent) {
        iOSMessagingEvent.removeAllListeners(Constants.AD_LOADED);
        iOSMessagingEvent.removeAllListeners(Constants.AD_DEFAULT_LOADED);
        iOSMessagingEvent.removeAllListeners(Constants.AD_CLOSED);
      }
    };
  }, []);

  return (
    <ScrollView>
      <View style={styles.container}>
        <Text style={styles.title}>Content Page</Text>

        <View style={styles.inlineViewContainer}>
          <Text style={styles.text}>Inline Spot</Text>
          <InlineAdView
            spotId={inline_spotId}
            viewId="inlineAdViewId"
            notVisible={inlineViewNotVisible}
            style={
              inlineViewNotVisible
                ? styles.inlineViewWithoutContent
                : styles.inlineViewWithContent
            }
          />
        </View>

        <View style={styles.interstitialViewContainer}>
          <Text style={styles.text}>Interstitial Spot</Text>
          <CustomButton
            title="Show Interstitial Ad"
            onPress={() => setShowInterstitial(true)}
            width={{ width: 200 }}
          />
          {showInterstitial && (
            <InterstitialAdView
              spotId={interstitial_spotId}
              viewId="interstitialViewId1"
            />
          )}
        </View>
      </View>
    </ScrollView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 16,
    marginTop: 20,
  },
  inlineViewContainer: {
    alignItems: 'center',
    justifyContent: 'space-around',
    borderWidth: 2,
    borderColor: 'lightgrey',
    borderRadius: 5,
    padding: 10,
    margin: 5,
  },
  inlineViewWithContent: {
    height: 300,
    width: 350,
    marginBottom: 50,
  },
  inlineViewWithoutContent: {
    height: 0,
    width: 350,
    marginBottom: 50,
  },
  interstitialViewContainer: {
    alignItems: 'center',
    borderColor: 'lightgrey',
    borderWidth: 2,
    borderRadius: 5,
    margin: 5,
    marginTop: 20,
  },
  text: {
    marginTop: 10,
    textAlign: 'center',
    fontWeight: 'bold',
  },
});

export default ContentScreen;
