import * as React from 'react';

import { StyleSheet, View, Text, TextInput, ScrollView } from 'react-native';
import * as MobileSdk from 'mobile-sdk-react-native';
import CustomButton from '../components/CustomButton';

const {newPage, addAppEvent, getTenantID, getTagServer, getDeviceID, getAppVersion } = MobileSdk;

export default function HomeScreen() {
    const [tenantID, setTenantID] = React.useState('');
    const [newPageUrl, setNewPageUrl] = React.useState('');
    const [eventName, setEventName] = React.useState('');
    const [attributeName, setAttributeName] = React.useState('');
    const [attributeValue, setAttributeValue] = React.useState('');
    const [tagServer, setTagServer] = React.useState('');
    const [deviceID, setDeviceID] = React.useState('');
    const [appVersion, setAppVersion] = React.useState('');

  return (
    <ScrollView>
    <View style={styles.container}>

          <TextInput style={styles.input} onChangeText={setNewPageUrl} value={newPageUrl} placeholder='New Page Uri' />
          <CustomButton
          width={{width: 200}}
          title="New Page"
          onPress={() => newPage(newPageUrl)}
          />


      <View style={styles.paddingView} />
      <TextInput style={styles.input} onChangeText={setEventName} value={eventName} placeholder='Event Name' />
      <TextInput style={styles.input} onChangeText={setAttributeName} value={attributeName} placeholder='Attribute Name' />
      <TextInput style={styles.input} onChangeText={setAttributeValue} value={attributeValue} placeholder='Attribute Value' />
      <CustomButton
        width={styles.buttonWidth}
        title="Add Event"
        onPress={() => addAppEvent(eventName, {[attributeName]: attributeValue})}
      />
      <View style={styles.paddingView} />
      <View style={styles.paddingView} />
      <CustomButton
        width={styles.buttonWidth}
        title='Get Tenant ID'
        onPress={() => {
          getTenantID((tID: string) => {
            setTenantID(tID);
          });
        }} />
        <Text>{tenantID}</Text>
        <View style={styles.paddingView} />
        <CustomButton width={styles.buttonWidth}
          title='Get Tag Server'
          onPress={() => {
            getTagServer((tagServer: string) => {
              setTagServer(tagServer);
            })
          }} />
          <Text>{tagServer}</Text>

          <View style={styles.paddingView} />
          <CustomButton
          width={styles.buttonWidth}
          title='Get Device ID'
          onPress={() => {
            getDeviceID((deviceID: string) => {
              setDeviceID(deviceID);
            })
          }} />
          <Text>{deviceID}</Text>

          <View style={styles.paddingView} />
          <CustomButton
          width={styles.buttonWidth}
          title='Get App Version'
          onPress={() => {
            getAppVersion((version: string) => {
              setAppVersion(version);
            })
          }} />
          <Text>{appVersion}</Text>
      </View>
      </ScrollView>
  );
}

const styles = StyleSheet.create({
    container: {
      flex: 1,
      alignItems: 'center',
      justifyContent: 'center',
    },
    input: {
      height: 40,
      width: 200,
      margin: 5,
      borderWidth: 1,
      padding: 5,
    },
    textStyle: {
      color: 'red',
      fontSize: 40
    },
    paddingView: {
      marginVertical: 10,
    },
    buttonWidth: {
      width: 200,
    }
  });
