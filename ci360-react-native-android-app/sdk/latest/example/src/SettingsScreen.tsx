import * as MobileSdk from 'mobile-sdk-react-native';
import React from 'react';
import {
  Alert,
  ScrollView,
  StyleSheet,
  Text,
  TextInput,
  TouchableOpacity,
  View,
} from 'react-native';
import Toast from 'react-native-simple-toast';
import Icon from 'react-native-vector-icons/Ionicons';
const { addAppEvent, detachIdentity, resetDeviceID } = MobileSdk;

const iconSize = 24;
const HomeScreen = ({ navigation }) => {
  const [eventName, setEventName] = React.useState('');
  const [attributeName, setAttributeName] = React.useState('');
  const [attributeValue, setAttributeValue] = React.useState('');

  const handleLogout = async () => {
    const isSuccess = await detachIdentity();
    if (isSuccess) {
      console.log('detach success');
      // setLoginType();
      // setIsLoggedIn(false);
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
  };

  // const handleDetachAndShutDown = async () => {
  //   console.log('handleDetachAndShutDown clicked');
  //   const isSuccess = await disableSDK();
  //   if (isSuccess) {
  //     console.log('disableSDK success');
  //     // setLoginType();
  //     // setIsLoggedIn(false);
  //     Alert.alert('Success', 'disableSDK Successful', [
  //       { text: 'OK', style: 'cancel', onPress: () => { navigation.goBack(); } }
  //     ]);

  //   } else {
  //     console.log('disableSDK failure');
  //     Alert.alert('Error', 'disableSDK failed', [
  //       { text: 'OK', style: 'cancel', onPress: () => { } }
  //     ]);
  //   }
  // }

  // const handleNewSession = async () => {
  //   const isSuccess = await detachIdentity();
  //   if (isSuccess) {
  //     console.log('detach success');
  //     Alert.alert('Success', 'For New session please login again', [
  //       { text: 'OK', style: 'cancel', onPress: () => { navigation.navigate('Profile') } }
  //     ]);
  //   } else {
  //     console.log('New session creation failure');
  //     Alert.alert('Error', 'New session creation failed', [
  //       { text: 'OK', style: 'cancel', onPress: () => { } }
  //     ]);
  //   }
  // }

  return (
    <ScrollView>
      <View style={styles.container}>
        <Text style={styles.title}>Settings</Text>
        <View style={styles.bar} />
        <View style={styles.buttonContainer}>
          <TouchableOpacity
            style={styles.button}
            onPress={() => navigation.navigate('Settings')}
          >
            <Icon name="log-out" size={iconSize} style={styles.icon} />
            <Text style={styles.buttonText} onPress={handleLogout}>
              Detech Identity
            </Text>
          </TouchableOpacity>
          <TouchableOpacity
            style={styles.button}
            onPress={() => navigation.navigate('Settings')}
          >
            <Icon name="close-circle" size={iconSize} style={styles.icon} />
            <Text
              style={styles.buttonText}
              onPress={() => {
                // handleDetachAndShutDown
              }}
            >
              Detech & Shutdown
            </Text>
          </TouchableOpacity>
        </View>
        <View style={styles.bar} />
        <View style={styles.buttonContainer}>
          <TouchableOpacity
            style={styles.button}
            onPress={() => navigation.navigate('Settings')}
          >
            <Icon
              name="extension-puzzle-outline"
              size={iconSize}
              style={styles.icon}
            />
            <Text style={styles.buttonText} onPress={() => {}}>
              Initialize CI360
            </Text>
          </TouchableOpacity>
          <TouchableOpacity
            style={styles.button}
            onPress={() => {
              resetDeviceID;
              Toast.show('New session intiated.');
            }}
          >
            <Icon
              name="paper-plane-outline"
              size={iconSize}
              style={styles.icon}
            />
            <Text style={styles.buttonText}>New Session</Text>
          </TouchableOpacity>
        </View>
        <View style={styles.bar} />
        <View style={styles.buttonContainer}>
          <TouchableOpacity
            style={styles.button}
            onPress={() => navigation.navigate('Settings')}
          >
            <Icon name="person-outline" size={iconSize} style={styles.icon} />
            <Text style={styles.buttonText}>Login (default user)</Text>
          </TouchableOpacity>
        </View>
        <View style={styles.bar} />
        <View style={styles.inputContainer}>
          <Text style={styles.inputLabel}>Event Name:</Text>
        </View>

        <TextInput
          style={styles.input}
          onChangeText={setEventName}
          value={eventName}
          placeholder="Event Name"
        />

        <View style={styles.inputContainer}>
          <Text style={styles.inputLabel}>Event Attribute:</Text>
        </View>
        <TextInput
          style={styles.input}
          onChangeText={setAttributeName}
          value={attributeName}
          placeholder="Attribute Name"
        />

        <View style={styles.inputContainer}>
          <Text style={styles.inputLabel}>Event Value:</Text>
        </View>
        <TextInput
          style={styles.input}
          onChangeText={setAttributeValue}
          value={attributeValue}
          placeholder="Event Attribute Value"
        />

        <TouchableOpacity
          style={styles.bigButton}
          onPress={() => {
            addAppEvent(eventName, { [attributeName]: attributeValue });
          }}
        >
          <Text style={styles.bigBtnText} id="testEvent">
            Submit Event
          </Text>
        </TouchableOpacity>
        <View style={styles.bar} />
      </View>
    </ScrollView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'top',
    alignItems: 'center',
    padding: 10,
    marginTop: 40,
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    padding: 20,
  },
  bar: {
    height: 1,
    width: '80%',
    backgroundColor: '#333',
  },
  buttonContainer: {
    marginVertical: 8,
    width: '80%',
  },
  button: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: 10,
  },
  buttonText: {
    fontSize: 24,
    marginLeft: 10,
    color: '#333',
  },
  icon: {
    size: 24,
    color: '#333',
    marginRight: 10,
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
  inputLabel: {
    fontWeight: 'bold',
    marginRight: 10,
    paddingRight: 20,
  },
  bigButton: {
    backgroundColor: '#0378cd',
    padding: 10,
    marginTop: 10,
    width: '50%',
    marginBottom: 20,
  },
  bigBtnText: {
    fontSize: 20,
    textAlign: 'center',
    color: '#FFF',
  },
});

export default HomeScreen;
