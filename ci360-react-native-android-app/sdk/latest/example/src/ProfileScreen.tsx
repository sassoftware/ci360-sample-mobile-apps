import React, { useContext, useEffect, useState } from 'react';
import {
  Alert,
  ScrollView,
  StyleSheet,
  Text,
  TextInput,
  TouchableOpacity,
  View,
} from 'react-native';
import Icon from 'react-native-vector-icons/Ionicons';
import { UserContext } from './UserContent';

import * as MobileSdk from 'mobile-sdk-react-native';
import MessagesScreen from './MessagesScreen';
import SpotsScreen from './SpotsScreen';

const { identity, detachIdentity, getSessionId, getDeviceID } = MobileSdk;

const ProfileScreen = ({ navigation }) => {
  const loginTypes = [
    { key: 'email_id', value: 'IDENTITY_TYPE_EMAIL' },
    { key: 'login_id', value: 'IDENTITY_TYPE_LOGIN' },
    { key: 'customer_id', value: 'IDENTITY_TYPE_CUSTOMER_ID' },
  ];
  const [, setDeviceID] = React.useState('');
  const [sessionID, setSessionID] = React.useState('');
  const [loginType, setLoginType] = React.useState(loginTypes[1]?.value);
  const [showAdViewScreen, setshowAdViewScreen] = React.useState(false);
  const [sendMessageInApp, setsendMessageInApp] = React.useState(false);

  const { isLoggedIn, setIsLoggedIn } = useContext(UserContext);
  const [email, setEmail] = useState('');
  const [emailError, setEmailError] = useState('');

  const handleSubmit = async () => {
    if (!email.trim()) {
      setEmailError('Email field cannot be empty.');
      setIsLoggedIn(false);
      if (email.length === 0) {
        return;
      }
    } else {
      setEmailError('');
      setEmail(email);
      setIsLoggedIn(true);
      const isSuccess = await identity(email, 'login_id');

      if (isSuccess) {
        setLoginType(loginType);
        setIsLoggedIn(true);
        console.log('Log-in success');
      } else {
        console.log('log-in failure');
        Alert.alert('Error', 'Log in failed', [
          { text: 'OK', style: 'cancel', onPress: () => {} },
        ]);
      }
    }
  };

  const handleLogout = async () => {
    const isSuccess = await detachIdentity();
    if (isSuccess) {
      console.log('detach success');
      setLoginType(loginType);
      setIsLoggedIn(false);
      // navigation.goBack();
      Alert.alert('Success', 'Detach identity Successful', [
        {
          text: 'OK',
          style: 'cancel',
          onPress: () => {
            navigation.goBack();
          },
        },
      ]);
    } else {
      console.log('detach failure');
      Alert.alert('Error', 'Detach identity failed', [
        { text: 'OK', style: 'cancel', onPress: () => {} },
      ]);
    }
    setLoginType(loginType);
    console.log('Logging out');
    setIsLoggedIn(false);
  };

  useEffect(() => {
    getDeviceID((deviceID: string) => {
      console.log('device id', deviceID);
      setDeviceID(deviceID);
    });
    getSessionId((sessionId: string) => {
      console.log('session Id', sessionId);
      setSessionID(sessionId);
    });
  }, []);
  // console.log("getSessionId::::", sessionID)
  return (
    <ScrollView>
      <View style={styles.container}>
        <View style={styles.twoColStrForButton}>
          <View style={styles.iconContainer}>
            <Icon
              name={isLoggedIn ? 'person' : 'person-add-outline'}
              size={35}
            />
          </View>

          <View>
            {isLoggedIn && (
              <TouchableOpacity
                style={[styles.bigButton, styles.logoutButton]}
                onPress={handleLogout}
              >
                <Text style={styles.bigBtnText}>Logout</Text>
              </TouchableOpacity>
            )}
          </View>
        </View>
        <Text>{sessionID.split('_=')[1]} </Text>
        {isLoggedIn && (
          <View style={styles.twoColStrForButton}>
            <Text>Welcome Back! {email}</Text>
            <View style={styles.indicatorContainer}>
              <Text>
                {isLoggedIn ? `Logged in as ${email}` : 'Logged Out'}.
              </Text>
            </View>
          </View>
        )}
      </View>
      {isLoggedIn ? (
        <>
          <View style={styles.bar} />
          <View style={styles.twoColStrForButton}>
            <TouchableOpacity
              style={styles.bigButton}
              onPress={() => {
                setshowAdViewScreen(true);
                setsendMessageInApp(false);
              }}
            >
              <Text style={styles.bigBtnText}>Show Ad View Screen</Text>
            </TouchableOpacity>

            <TouchableOpacity
              style={styles.bigButton}
              onPress={() => {
                setsendMessageInApp(true);
                setshowAdViewScreen(false);
              }}
            >
              <Text style={styles.bigBtnText}>Send Message In App</Text>
            </TouchableOpacity>
          </View>
          {sendMessageInApp && <MessagesScreen />}
          {showAdViewScreen && <SpotsScreen spotId={'GP_spot1'} />}
        </>
      ) : (
        <>
          <View style={styles.container}>
            <View style={styles.bar} />
            <View style={styles.inputContainer}>
              <Text style={styles.inputLabel}>Email:</Text>
            </View>

            <TextInput
              placeholder="Email"
              autoCapitalize="none"
              autoCorrect={false}
              keyboardType="email-address"
              style={styles.input}
              onChangeText={(e) => {
                setEmail(e);
                setEmailError('');
              }}
            />

            <View style={styles.inputContainer}>
              <Text style={styles.inputLabel}>Password:</Text>
            </View>

            <TextInput
              placeholder="Password"
              secureTextEntry
              keyboardType="default"
              style={styles.input}
            />
            <Text style={styles.red}>{emailError}</Text>
            <TouchableOpacity style={styles.bigButton} onPress={handleSubmit}>
              <Text style={styles.bigBtnText}>Login</Text>
            </TouchableOpacity>
            <View style={styles.bar} />
          </View>
        </>
      )}
    </ScrollView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'top',
    alignItems: 'center',
    padding: 10,
    marginTop: 20,
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    padding: 20,
  },
  red: {
    color: 'red',
  },
  bar: {
    height: 1,
    width: '100%',
    backgroundColor: '#333',
  },
  inputContainer: {
    width: '80%',
    flexDirection: 'row',
    alignItems: 'center',
    padding: 10,
  },
  input: {
    borderWidth: 1,
    borderColor: 'gray',
    backgroundColor: 'white',
    padding: 10,
    borderRadius: 5,
    width: '70%',
  },
  inputlabel: {
    fontWeight: 'bold',
    marginRight: 10,
    paddingRight: 20,
  },
  bigButton: {
    backgroundColor: '#0378cd',
    padding: 10,
    marginTop: 10,
    width: '45%',
    marginBottom: 20,
    marginRight: 10,
  },
  bigBtnText: {
    fontSize: 20,
    textAlign: 'center',
    color: '#FFF',
  },
  iconContainer: {
    borderRadius: 50,
    borderWidth: 2,
    borderColor: '#000',
    padding: 10,
    marginBottom: 20,
    height: 60,
    width: 60,
  },
  indicatorContainer: {
    // position: 'absolute',
    height: 50,
    bottom: 0,
    padding: 10,
    justifyContent: 'center',
    alignItems: 'center',
  },
  twoColStrForButton: {
    display: 'flex',
    justifyContent: 'space-around',
    flexDirection: 'row',
    alignItems: 'center',
    width: '100%',
  },
  logoutButton: {
    width: '100%',
    height: 50,
  },
});

export default ProfileScreen;
