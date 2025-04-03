import * as React from 'react';
import { DeviceEventEmitter, Platform, NativeEventEmitter } from 'react-native';
import Icon from 'react-native-vector-icons/Ionicons';
import { check, request, PERMISSIONS, RESULTS } from 'react-native-permissions';
import Toast from 'react-native-simple-toast';
import {
  type LinkingOptions,
  NavigationContainer,
} from '@react-navigation/native';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { createStackNavigator } from '@react-navigation/stack';
import {
  newPage,
  SASMobileMessagingEvent,
  Constants,
  startMonitoringLocation,
  setAppVersionAndInitSDK,
  registerForMobileMessage,
} from 'mobile-sdk-react-native';
import { EventEmitter as EvtEmitter } from 'events';

import HomeScreen from './screens/HomeScreen';
import SettingsScreen from './screens/SettingsScreen';
import NotificationsScreen from './screens/NotificationsScreen';
import ProfileScreen from './screens/ProfileScreen';
import ContentScreen from './screens/ContentScreen';
import SearchScreen from './screens/SearchScreen';
import ConfigScreen from './screens/ConfigScreen';
import {
  navigate,
  RootTabParameterList,
  navigationRef,
} from './RootNavigation';
import { UserProvider } from './screens/UserContent';

const Tab = createBottomTabNavigator();
const HomeStack = createStackNavigator();

const HomeStackNavigator = () => (
  <HomeStack.Navigator
    screenOptions={{
      headerStyle: {
        backgroundColor: '#0378cd',
      },
      headerTintColor: '#fff',
    }}
  >
    <HomeStack.Screen
      name="HomeStack"
      component={HomeScreen}
      options={{ title: '' }}
    />
    <HomeStack.Screen
      name="Notifications"
      component={NotificationsScreen}
      options={{
        tabBarStyle: { backgroundColor: '#d3d3d3' },
        tabBarInactiveTintColor: 'grey',
      }}
    />
    <HomeStack.Screen name="Content" component={ContentScreen} />
    <HomeStack.Screen name="Search" component={SearchScreen} />
  </HomeStack.Navigator>
);

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
    Toast.show(
      'Not enough location permission. Please set location permission to always to enable geofence',
      1
    );
  } else if (Platform.OS === 'android') {
    let status1 = await check(PERMISSIONS.ANDROID.ACCESS_COARSE_LOCATION);
    let status2 = await check(PERMISSIONS.ANDROID.ACCESS_FINE_LOCATION);
    let status3 = await check(PERMISSIONS.ANDROID.ACCESS_BACKGROUND_LOCATION);
    if (
      status1 === RESULTS.GRANTED &&
      status2 === RESULTS.GRANTED &&
      status3 === RESULTS.GRANTED
    ) {
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
    if (
      status1 !== RESULTS.GRANTED &&
      status2 === RESULTS.GRANTED &&
      status3 === RESULTS.GRANTED
    ) {
      Toast.show(
        'Not enough location permission. \
      Please set location permission to always to enable geofence',
        Toast.SHORT
      );
    }
  }
}

type Props = {
  notificationWithLink: string | null;
};

const emitter = new EvtEmitter();

const App: React.FC<Props> = ({ notificationWithLink }) => {
  const [initialTab, setInitialTab] = React.useState('Config');

  let iOSMessagingEvent: NativeEventEmitter;
  if (SASMobileMessagingEvent != null) {
    iOSMessagingEvent = new NativeEventEmitter(SASMobileMessagingEvent);
  }

  React.useEffect(() => {
    // This happens when the app is not started yet. Tapping push notification starts the app.
    //notificationWithLink is a parameter in the initial props passed from the native side.
    if (notificationWithLink && notificationWithLink?.includes('diagnostics')) {
      Toast.show(
        'User got push notification with link' + notificationWithLink,
        Toast.SHORT
      );
      setInitialTab('Diagnostics');
    }

    if (Platform.OS === 'android') {
      setAppVersionAndInitSDK('1.0.1');
      DeviceEventEmitter.addListener(Constants.MESSAGE_DISMISSED, () => {
        console.log('User dismissed the message');
        Toast.show('User dismissed message', Toast.SHORT);
      });
      DeviceEventEmitter.addListener(
        Constants.MESSAGE_OPENED,
        (obj: { [key: string]: string }) => {
          const link = obj['link'];
          const msg = 'User got in-app msg with link:' + link;
          Toast.show(msg, Toast.SHORT);
          if (link?.includes('diagnostic')) {
            navigate('Diagnostics', { link: link });
          }
        }
      );

      DeviceEventEmitter.addListener(
        Constants.MESSAGE_NOTIFICATION_LINK_RECEIVED,
        (link: string) => {
          if (link.includes('diagnostic')) {
            Toast.show(
              'User got push notification' + ' with link' + link,
              Toast.SHORT
            );

            // This event is for the listener in deep link to listen to
            emitter.emit('PushLink', { link: link });
          }
        }
      );
    } else if (Platform.OS === 'ios') {
      setAppVersionAndInitSDK('1.2.2');
      iOSMessagingEvent.addListener(Constants.REGISTER_DEVICE_TOKEN, (data) => {
        console.log('tokenData: ' + data);
        const token = data.deviceToken;
        registerForMobileMessage(token);
      });
      iOSMessagingEvent.addListener(Constants.MESSAGE_OPENED, (data) => {
        console.log('data: ' + data);
        console.log('message type: ' + data.type + 'link is: ' + data.link);
        const msg =
          data.type === 'InAppMsg'
            ? 'User got in-app msg with link:' + data.link
            : 'User got push notification with link:' + data.link;
        Toast.show(msg, Toast.SHORT);

        if (data.type === 'InAppMsg') {
          navigate('Diagnostics', { link: data.link });
        } else {
          // This event is for the listener in deep link to listen for
          emitter.emit('PushLink', { link: data.link });
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
    };
  }, []);

  checkLocationPermission();

  const config = {
    screens: {
      Diagnostics: 'diagnostics',
    },
  };

  const linking: LinkingOptions<RootTabParameterList> = {
    prefixes: ['ci360://'],
    config: {
      screens: {
        Home: {
          initialRouteName: 'home',
          screens: {
            HomeStack: 'homestack',
            ProfileStack: 'profilestack',
            Notifications: 'notifications',
            Content: 'content',
            Search: 'search',
          },
        },
        Profile: 'profile',
        Settings: 'settings',
        Config: 'config',
      },
    },
    subscribe(listener: any) {
      const pushSub = emitter.addListener('PushLink', (data: any) => {
        listener(data.link);
      });
      return () => {
        pushSub.removeAllListeners();
      };
    },
  };

  return (
    <UserProvider>
      <NavigationContainer
        linking={linking}
        ref={navigationRef}
        onStateChange={() => {
          const currentRoute = navigationRef.getCurrentRoute();
          if (currentRoute) {
            newPage(currentRoute.name);
            console.log('new page:', currentRoute.name);
          }
        }}
        onReady={() => {
          const currentRoute = navigationRef.getCurrentRoute();
          if (currentRoute) {
            newPage(currentRoute.name);
            console.log('new page:', currentRoute.name);
          }
        }}
      >
        <Tab.Navigator
          id={undefined}
          initialRouteName={initialTab}
          screenOptions={({ route }) => ({
            tabBarIcon: ({ focused, color, size }) => {
              let iconName;
              if (route.name === 'Home') {
                iconName = focused ? 'home' : 'home-outline';
              } else if (route.name === 'Profile') {
                iconName = focused ? 'person' : 'person-outline';
              } else if (route.name === 'Settings') {
                iconName = focused ? 'settings' : 'settings-outline';
              } else if (route.name === 'Config') {
                iconName = focused ? 'options' : 'options-outline';
              }
              return <Icon name={iconName} size={size} color={color} />;
            },
            tabBarActiveTintColor: '#0378cd',
            tabBarInactiveTintColor: 'gray',
            headerStyle: { backgroundColor: '#0378cd' },
            headerTintColor: '#fff',
          })}
        >
          <Tab.Screen
            name="Home"
            component={HomeStackNavigator}
            options={{ headerShown: false }}
          />
          <Tab.Screen name="Profile" component={ProfileScreen} />
          <Tab.Screen name="Settings" component={SettingsScreen} />
          <Tab.Screen name="Config" component={ConfigScreen} />
        </Tab.Navigator>
      </NavigationContainer>
    </UserProvider>
  );
};

export default App;
