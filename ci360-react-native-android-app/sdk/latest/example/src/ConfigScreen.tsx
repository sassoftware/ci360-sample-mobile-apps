import * as MobileSdk from 'mobile-sdk-react-native';
import React, { useEffect } from 'react';
import {
  ScrollView,
  StyleSheet,
  Text,
  TextInput,
  TouchableOpacity,
  View,
} from 'react-native';
import Toast from 'react-native-simple-toast';
const {
  defineAppId,
  defineAppVersion,
  defineTenantID,
  defineTagServer,
  getDeviceID,
} = MobileSdk;

const HomeScreen = ({ navigation }) => {
  const [appId, setAppId] = React.useState('');
  const [appVersion] = React.useState('');
  const [tagServer, setTagServer] = React.useState('');
  const [, setDeviceID] = React.useState('');
  const [tenantID, setTenantID] = React.useState('');

  const handleApplyConfig = () => {
    console.log('Executed handleApplyConfig');
    defineAppId(appId);
    defineAppVersion(appVersion);
    defineTenantID(tenantID);
    defineTagServer(tagServer);
    console.log(
      'Config set properly, login now',
      appId,
      appVersion,
      tenantID,
      tagServer
    );
    Toast.show('Config set properly, login now');
    setTimeout(() => {
      navigation.navigate('Profile');
    }, 3000);
  };

  useEffect(() => {
    getDeviceID((deviceId: string) => {
      console.log('device id', deviceId);
      setDeviceID(deviceId);
    });
  }, []);
  return (
    <ScrollView>
      <View style={styles.container}>
        <Text style={styles.title}>Config CI360 SDK</Text>
        <View style={styles.bar} />
        <View style={styles.inputContainer}>
          <Text style={styles.inputLabel}>Tenant ID:</Text>
        </View>
        <Text style={styles.inputReferenceLabel}> {tenantID} </Text>
        <TextInput
          placeholder="Tenant ID"
          style={styles.input}
          onChangeText={setTenantID}
          value={tenantID}
        />

        <View style={styles.inputContainer}>
          <Text style={styles.inputLabel}>App ID:</Text>
        </View>
        <Text style={styles.inputReferenceLabel}> {appId} </Text>
        <TextInput
          placeholder="Application ID"
          style={styles.input}
          value={appId}
          onChangeText={setAppId}
        />

        <View style={styles.inputContainer}>
          <Text style={styles.inputLabel}>Tag Server:</Text>
        </View>
        <Text style={styles.inputReferenceLabel}> {tagServer} </Text>
        <TextInput
          placeholder="Tag Server URL"
          style={styles.input}
          value={tagServer}
          onChangeText={setTagServer}
        />

        <TouchableOpacity style={styles.bigButton} onPress={handleApplyConfig}>
          <Text style={styles.bigBtnText}>Apply Config</Text>
        </TouchableOpacity>
        <View style={styles.bar} />
        <Text style={styles.inputLabel}>App version: {appVersion}</Text>
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
  inputReferenceLabel: {
    fontWeight: 'normal',
    marginLeft: 10,
    paddingLeft: 20,
    paddingBottom: 6,
    width: '80%',
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
