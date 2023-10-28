import * as React from 'react';
import { DeviceEventEmitter, Platform, StyleSheet, NativeEventEmitter, Linking, EventEmitter} from 'react-native';
// import AntDesign from 'react-native-vector-icons/AntDesign';
import FontAwesome from 'react-native-vector-icons/FontAwesome';
//import {check, request, PERMISSIONS, RESULTS } from 'react-native-permissions';
import Toast from 'react-native-simple-toast';

import { LinkingOptions, NavigationContainer } from '@react-navigation/native';
import { BottomTabBarProps, createBottomTabNavigator } from '@react-navigation/bottom-tabs';

//import { SASMobileMessagingEvent, Constants, startMonitoringLocation } from 'mobile-sdk-react-native';
import { SASMobileMessagingEvent, Constants } from 'mobile-sdk-react-native';
import {EventEmitter as EvtEmitter} from 'events';

import HomeScreen from './screens/HomeScreen';
import LoginStack from './screens/LoginStack';
import SpotsScreen from './screens/SpotsScreen';
import MessagesScreen from './screens/MessagesScreen';
import DiagnosticScreen from './screens/DiagnosticScreen';
import {navigate, RootTabParameterList} from './RootNavigation';

const Tab = createBottomTabNavigator();
/*
async function checkLocationPermission()   {
  if (Platform.OS === 'ios') {
    let statusIOS = await check(PERMISSIONS.IOS.LOCATION_ALWAYS);
    if (statusIOS === RESULTS.GRANTED) {
      startMonitoringLocation();
      return;
    }
    statusIOS = await request('ios.permission.LOCATION_ALWAYS');
    if (statusIOS === RESULTS.GRANTED) {
      startMonitoringLocation();
      return;
    }
    Toast.show('Not enough location permission. Please set location permission to always to enable geofence');

  } else if (Platform.OS == 'android') {
    let status1 = await check(PERMISSIONS.ANDROID.ACCESS_COARSE_LOCATION);
    let status2 = await check(PERMISSIONS.ANDROID.ACCESS_FINE_LOCATION);
    let status3 = await check(PERMISSIONS.ANDROID.ACCESS_BACKGROUND_LOCATION);
    if (status1 == RESULTS.GRANTED && status2 === RESULTS.GRANTED && status3 === RESULTS.GRANTED) {
      startMonitoringLocation();
      return;
    }
    if (status1 !== RESULTS.GRANTED) {
      status1 = await request('android.permission.ACCESS_COARSE_LOCATION');
    }
    if (status2 !== RESULTS.GRANTED) {
      status2 = await request('android.permission.ACCESS_FINE_LOCATION');
    }
    if (status3 !== RESULTS.GRANTED) {
      status3 = await request('android.permission.ACCESS_BACKGROUND_LOCATION');
    }
    if (status1 !== RESULTS.GRANTED && status2 === RESULTS.GRANTED && status3 === RESULTS.GRANTED) {
      Toast.show('Not enough location permission. \
      Please set location permission to always to enable geofence');
    }
  }
}
*/
type Props = {
  notificationWithLink: string | null
}

const emitter = new EvtEmitter();

const  App: React.FC<Props> = ({notificationWithLink}) => {

  const [initialTab, setInitialTab] = React.useState('Identity');

  let iOSMessagingEvent: NativeEventEmitter;
  if (SASMobileMessagingEvent != null) {
    iOSMessagingEvent = new NativeEventEmitter(SASMobileMessagingEvent);
  }

  React.useEffect(() => {

    // This happens when the app is not started yet. Tapping push notification starts the app.
    //notificationWithLink is a parameter in the initial props passed from the native side.
    if (notificationWithLink && notificationWithLink?.includes('diagnostics')) {
      Toast.show('User got push notification with link' + notificationWithLink, Toast.SHORT);
      setInitialTab('Diagnostics');
    }

     if (Platform.OS === 'android') {
      DeviceEventEmitter.addListener(Constants.MESSAGE_DISMISSED, () => {
        console.log('User dismissed the message');
        Toast.show('User dismissed message', Toast.SHORT);
      });
      DeviceEventEmitter.addListener(Constants.MESSAGE_OPENED, (obj: {[key: string]: string}) => {
        const link = obj['link'];
        const msg = 'User got in-app msg with link:' + link;
        Toast.show(msg, Toast.SHORT);
        if (link?.includes('diagnostic')) {
          navigate('Diagnostics', {link: link});
        }
      });

      DeviceEventEmitter.addListener(Constants.MESSAGE_NOTIFICATION_LINK_RECEIVED, (link: string) => {
        if (link.includes('diagnostic')) {
          Toast.show('User got push notification' +
          ' with link' + link, Toast.SHORT);

          // This event is for the listener in deep link to listen to
          emitter.emit('PushLink', {link: link})
        }
      });

    } else if (Platform.OS === 'ios') {
      iOSMessagingEvent.addListener(Constants.MESSAGE_OPENED, (data) => {
        console.log('data: ' + data);
        console.log('message type: ' + data.type + 'link is: ' + data.link);
        const msg = (data.type === 'InAppMsg' ? 'User got in-app msg with link:' + data.link : 'User got push notification with link:' + data.link);
        Toast.show(msg, Toast.SHORT);

        if (data.type === 'InAppMsg') {
          navigate('Diagnostics', {link: data.link});
        } else {
          // This event is for the listener in deep link to listen for
          emitter.emit('PushLink', {link: data.link})
        }

      });
      iOSMessagingEvent.addListener(Constants.MESSAGE_DISMISSED, () => {
        Toast.show('User dismissed message', Toast.SHORT);
      });
    }

    return () => {
      DeviceEventEmitter.removeAllListeners();
      if (SASMobileMessagingEvent) {
        iOSMessagingEvent.removeAllListeners(SASMobileMessagingEvent);
      }
    }

  }, []);
/*
  checkLocationPermission();
*/
  const config = {
    screens: {
      Diagnostics: 'diagnostics'
    }
  }


  const linking: LinkingOptions<RootTabParameterList> = {
    prefixes: ['app://'],
    config: config,
    subscribe(listener: any) {
      const pushSub = emitter.addListener('PushLink', (data: any) => {
        listener(data.link)
      })
      return () => {
        pushSub.removeAllListeners()
      }
    }
  };


  return (
    <NavigationContainer linking={linking}>
      <Tab.Navigator

        initialRouteName={initialTab}

        screenOptions={({route}) => ({
          tabBarIcon: ({ focused, color, size}) => {
            let iconName;
            if (route.name === 'Home') {
              iconName = 'home';
            } else if(route.name === 'Identity') {
              iconName = 'sign-in';
            } else if (route.name === 'Views') {
              iconName = 'film';
            }
            else if (route.name === 'Diagnostics') {
              iconName = 'gear';
            } else if (route.name === 'Messages') {
              iconName = 'comment';
            }
            return <FontAwesome name={iconName} size={size} color={color} />
          },
          tabBarActiveTintColor: 'tomato',
          tabBarInactiveTintColor: 'gray',
        })}
      >
        <Tab.Screen name='Identity' component={LoginStack} options={{headerShown: false}}  />
        <Tab.Screen name='Home' component={HomeScreen} />
        <Tab.Screen name='Views' component={SpotsScreen} />
        <Tab.Screen name='Messages' component={MessagesScreen} />
        <Tab.Screen name='Diagnostics' component={DiagnosticScreen} options={{tabBarLabel: 'diagnostics'}} />
      </Tab.Navigator>
    </NavigationContainer>
  );
}

export default App;

