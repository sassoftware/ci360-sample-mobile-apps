import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { LinkingOptions, NavigationContainer } from '@react-navigation/native';
import { createStackNavigator } from '@react-navigation/stack';
import * as MobileSdk from 'mobile-sdk-react-native';
import React, { useEffect } from 'react';
import { PERMISSIONS, RESULTS, check, request } from 'react-native-permissions';
import Toast from 'react-native-simple-toast';
import Icon from 'react-native-vector-icons/Ionicons';
import { UserProvider } from './UserContent';
// import your screen components for each tab
import { EventEmitter as EvtEmitter } from 'events';
import { DeviceEventEmitter, NativeEventEmitter, Platform } from 'react-native';
import ConfigScreen from './ConfigScreen';
import ContentScreen from './ContentScreen';
import HomeScreen from './HomeScreen';
import NotificationsScreen from './NotificationsScreen';
import ProfileScreen from './ProfileScreen';
import SearchScreen from './SearchScreen';
import SettingsScreen from './SettingsScreen';
import CartEventsTestScreen from './TestDemo/CartEvents';
import EventsTestScreen from './TestDemo/EventsTest';
import DemoListExamples from './TestDemo/TestDemo';
const { SASMobileMessagingEvent, Constants, startMonitoringLocation } = MobileSdk;

const appName = 'GCI App';
async function checkLocationPermission() {
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
      Toast.show('Not enough location permission. Please set location permission to always to enable geofence');
    }
  }
}

const Tab = createBottomTabNavigator();
const Stack = createStackNavigator();

const stackScreenOptions = ({ route }) => ({
  headerTitle: `${appName} - ${route.name}`,
  headerStyle: { backgroundColor: '#0378cd' },
  headerTintColor: '#FFF'
});

const HomeStack = ({ initialParams }) => (
  <Stack.Navigator screenOptions={stackScreenOptions}>
    <Stack.Screen name="HomeStack" component={HomeScreen} />
    <Stack.Screen name="ProfileStack" component={ProfileScreen} />
    <Stack.Screen name="Notifications" component={NotificationsScreen} />
    <Stack.Screen name="Content" component={ContentScreen} initialParams={initialParams} />
    <Stack.Screen name="Search" component={SearchScreen} />
    <Stack.Screen name="DemoList" component={DemoListExamples} />
    <Stack.Screen name="Events" component={EventsTestScreen} />
    <Stack.Screen name="CartEvents" component={CartEventsTestScreen} />

  </Stack.Navigator>
);

const tabScreenOptions = ({ route }) => ({
  headerShown: false,
  tabBarIcon: ({ focused, color, size }) => {
    let iconName;
    if (route.name === 'Home') {
      iconName = focused ? 'home' : 'home-outline';
      color = focused ? '#0378cd' : null;
    } else if (route.name === 'Settings') {
      iconName = focused ? 'settings' : 'settings-outline';
      color = focused ? '#0378cd' : null;
    } else if (route.name === 'Config') {
      iconName = focused ? 'hammer' : 'hammer-outline';
      color = focused ? '#0378cd' : null;
    } else if (route.name === 'Profile') {
      iconName = focused ? 'person' : 'person-outline';
      color = focused ? '#0378cd' : null;
    }
    // You can return any component that you like here!
    return <Icon name={iconName} size={size} color={color} />;
  },
})

// const App = ({ navigate, notificationWithLink }) => {
type Props = {
  notificationWithLink: string | null,
  navigate: string | null,
  initialProps: object | null,
}

const emitter = new EvtEmitter();
const App: React.FC<Props> = ({ navigate, notificationWithLink, initialProps }) => {
  const [initialTab, setInitialTab] = React.useState('Home');
  console.log("notificationWithLink::::;", notificationWithLink, initialProps)
  // let notificationWithLink = "";
  // checkLocationPermission()
  let iOSMessagingEvent: NativeEventEmitter;
  if (SASMobileMessagingEvent != null) {
    iOSMessagingEvent = new NativeEventEmitter(SASMobileMessagingEvent);
  }
  // let pushLink = '';
  React.useEffect(() => {
    //Tapping push notification starts the app.
    //notificationWithLink is a parameter in the initial props passed from the native side.

    if (notificationWithLink && (notificationWithLink.includes('diagnostics') || notificationWithLink.includes('content'))) {
      Toast.show('User got push notification with link' + notificationWithLink, Toast.SHORT);
      setInitialTab('Diagnostics');
      console.log("Setting diagnostics tabs")
    }

    if (Platform.OS === 'android') {
      DeviceEventEmitter.addListener(Constants.MESSAGE_DISMISSED, () => {
        console.log('User dismissed the message');
        Toast.show('User dismissed message', Toast.SHORT);
      });
      DeviceEventEmitter.addListener(Constants.MESSAGE_OPENED, (obj: { [key: string]: string }) => {
        const link = obj['link'];
        const msg = 'User got in-app msg with link:' + link;
        Toast.show(msg, Toast.SHORT);
        if (link?.includes('diagnostic')) {
          navigate('Content', { link: link });
        }
      });

      DeviceEventEmitter.addListener(Constants.MESSAGE_NOTIFICATION_LINK_RECEIVED, (link: string) => {
        if (link.includes('diagnostic')) {
          Toast.show('User got push notification' +
            ' with link' + link, Toast.SHORT);

          // This event is for the listener in deep link to listen to
          emitter.emit('PushLink', { link: link })
        }
      });

    } else if (Platform.OS === 'ios') {
      iOSMessagingEvent.addListener(Constants.MESSAGE_OPENED, (data) => {
        console.log('data: ' + data);
        console.log('message type: ' + data.type + 'link is: ' + data.link);
        const msg = (data.type === 'InAppMsg' ? 'User got in-app msg with link:' + data.link : 'User got push notification with link:' + data.link);
        Toast.show(msg, Toast.SHORT);
        // navigate('Diagnostics', {link: data.link});
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

  checkLocationPermission();

  const config = {
    screens: {
      Diagnostics: 'diagnostics'
    }
  }

  let tabName = 'Home';
  let pushLink = '';
  if (notificationWithLink && notificationWithLink.includes('diagnostics')) {
    tabName = 'Diagnostics'
    pushLink = notificationWithLink;
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

  useEffect(() => {
    // registerForMobileMessage("token");
  }, []);
  return (
    <UserProvider >
      <NavigationContainer linking={linking}>
        <Tab.Navigator initialRouteName={initialTab} screenOptions={tabScreenOptions}>
          <Tab.Screen name="Home" component={HomeStack} />
          <Tab.Screen name="Profile" component={ProfileScreen} />
          <Tab.Screen name="Settings" component={SettingsScreen} />
          <Tab.Screen name="Config" component={ConfigScreen} />
        </Tab.Navigator>
      </NavigationContainer>
    </UserProvider>
  )
}

export default App;