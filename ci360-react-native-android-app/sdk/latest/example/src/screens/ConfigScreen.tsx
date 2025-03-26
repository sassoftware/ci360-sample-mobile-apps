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
  setAppId,
  setTagServer,
  setTenantId,
  getDeviceID,
} = MobileSdk;
import styles from './Styles/style';  

const appVersion = '1.0';

interface ConfigScreenProps {
  navigation: any;
}

const ConfigScreen: React.FC<ConfigScreenProps> = ({ navigation }) => {
  const [appId, defineAppId] = React.useState('');
  const [tagServer, defineTagServer] = React.useState('');
  const [, defineDeviceID] = React.useState('');
  const [tenantID, defineTenantId] = React.useState('');
  const handleApplyConfig = () => {
    console.log('Executed handleApplyConfig');
    setAppId(appId);
    setTenantId(tenantID);
    setTagServer(tagServer);
    console.log(
      'Config set properly, login now',
      appId,
      tenantID,
      tagServer
    );
    Toast.show('Config set properly, login now', Toast.LONG);
    setTimeout(() => {
      navigation.navigate('Profile');
    }, 3000);
  };

  useEffect(() => {
    getDeviceID((deviceId: string) => {
      console.log('device id', deviceId);
      defineDeviceID(deviceId);
    });
  }, []);
  return (
    <View style={styles.container}>
        <Text style={styles.title}>Config CI360 SDK</Text>
        <View style={styles.bar} />
        <View style={styles.inputContainer}>
          <Text style={styles.inputLabel}>Tenant ID:</Text>
        </View>
        <TextInput
          placeholder="Tenant ID"
          style={styles.input}
          onChangeText={defineTenantId}
          value={tenantID}
        />

        <View style={styles.inputContainer}>
          <Text style={styles.inputLabel}>App ID:</Text>
        </View>
        
        <TextInput
          placeholder="Application ID"
          style={styles.input}
          value={appId}
          onChangeText={defineAppId}
        />

        <View style={styles.inputContainer}>
          <Text style={styles.inputLabel}>Tag Server:</Text>
        </View>
        
        <TextInput
          placeholder="Tag Server URL"
          style={styles.input}
          value={tagServer}
          onChangeText={defineTagServer}
        />

        <TouchableOpacity style={styles.bigButton} onPress={handleApplyConfig}>
          <Text style={styles.bigBtnText}>Apply Config</Text>
        </TouchableOpacity>
        <View style={styles.bar} />
        <Text style={styles.inputLabel}>App version: {appVersion}</Text>
        <Text style={styles.inputReferenceLabel}>Tenant ID:</Text>
        <Text style={styles.inputReferenceLabel}> {tenantID} </Text> 
        <Text style={styles.inputReferenceLabel}>Tag Server URL: </Text>
        <Text style={styles.inputReferenceLabel}> {tagServer} </Text>
        <Text style={styles.inputReferenceLabel}>Application ID: </Text>
        <Text style={styles.inputReferenceLabel}> {appId} </Text>
      </View>
  );
};

export default ConfigScreen;