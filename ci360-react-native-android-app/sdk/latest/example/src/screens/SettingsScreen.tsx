//
//#*************************************************************************************************************#
//# Application Name: SAS CI360 React Native Demo Application                                                        #
//# File Name: SettingsScreen.tsx                                                                                   #
//# File Description: Settings screen for app controls, identity/session utilities, and custom event submission. #
//# Author: SAS Global CX-CI                                                                                    #
//# Date: 31-October-2023       
//# Copyright  2026, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.                                   #
//# SPDX-License-Identifier: Apache-2.0                                                                         #
//#*************************************************************************************************************#
//
import React from 'react';
import { View, Text, TextInput, TouchableOpacity } from 'react-native';
import Icon from 'react-native-vector-icons/Ionicons';
import Toast from 'react-native-simple-toast';
import styles from './Styles/style';
import * as MobileSdk from 'mobile-sdk-react-native';
import {
  DEFAULT_CI360_SETTINGS,
  getCi360Settings,
  updateCi360Settings,
} from '../services/Ci360SettingsStore';

const {
  detachIdentity,
  setAppVersionAndInitSDK,
  addAppEvent,
  resetDeviceID
} = MobileSdk;

const iconSize = 24;
const appVersion = '1.0.0';

interface SettingsScreenProps {
  navigation: any;
}

const SettingsScreen: React.FC<SettingsScreenProps> = ({ navigation }) => {
  const [eventName, setEventName] = React.useState('');
  const [attributeName, setAttributeName] = React.useState('');
  const [attributeValue, setAttributeValue] = React.useState('');
  const [gatewayHost, setGatewayHost] = React.useState(DEFAULT_CI360_SETTINGS.gatewayHost);
  const [externalTenantId, setExternalTenantId] = React.useState(
    DEFAULT_CI360_SETTINGS.externalTenantId
  );

  React.useEffect(() => {
    const settings = getCi360Settings();
    setGatewayHost(settings.gatewayHost);
    setExternalTenantId(settings.externalTenantId);
  }, []);

  const handleSaveCi360Settings = () => {
    const saved = updateCi360Settings({
      gatewayHost,
      externalTenantId,
    });
    setGatewayHost(saved.gatewayHost);
    setExternalTenantId(saved.externalTenantId);
    Toast.show('CI360 gateway and tenant saved', Toast.SHORT);
  };

  return (
    <View style={styles.tabContainer}>
    
      <Text style={styles.title}>Settings</Text>

      <View style={styles.bar} />

      <View style={styles.inputContainer}>
        <Text style={styles.inputLabel}>External Gateway Host:</Text>
      </View>
      <TextInput
        style={styles.input}
        onChangeText={setGatewayHost}
        value={gatewayHost}
        placeholder="https://execution-training.ci360.sas.com"
        autoCapitalize="none"
      />

      <View style={styles.inputContainer}>
        <Text style={styles.inputLabel}>External Tenant ID:</Text>
      </View>
      <TextInput
        style={styles.input}
        onChangeText={setExternalTenantId}
        value={externalTenantId}
        placeholder="tenant id"
        autoCapitalize="none"
      />

      <TouchableOpacity style={styles.bigButton} onPress={handleSaveCi360Settings}>
        <Text style={styles.bigBtnText}>Save CI360 Settings</Text>
      </TouchableOpacity>

      <View style={styles.bar} />

      <View style={styles.buttonContainer}>
      
        <TouchableOpacity
          style={styles.button}
          onPress={() => detachIdentity()}  
        >
          <Icon name="log-out" size={iconSize} style={styles.icon} />
          <Text style={styles.buttonText}>Detach Identity</Text>
        </TouchableOpacity>

        <TouchableOpacity
          style={styles.button}
          onPress={() => {
            detachIdentity();
            setAppVersionAndInitSDK(appVersion);
          }}
        >
          <Icon name="close-circle" size={iconSize} style={styles.icon} />
          <Text style={styles.buttonText}>Detach & Reinitialize</Text>
        </TouchableOpacity>

      </View>

      <View style={styles.bar} />

      <View style={styles.buttonContainer}>
       
        <TouchableOpacity
          style={styles.button}
          onPress={() => setAppVersionAndInitSDK(appVersion)} 
        >
          <Icon name="extension-puzzle-outline" size={iconSize} style={styles.icon} />
          <Text style={styles.buttonText}>Initialize CI360</Text>
        </TouchableOpacity>

        <TouchableOpacity
          style={styles.button}
          onPress={() => {
            detachIdentity();
            setAppVersionAndInitSDK(appVersion);
          }}
        >
          <Icon name="paper-plane-outline" size={iconSize} style={styles.icon} />
          <Text style={styles.buttonText}>New Session</Text>
        </TouchableOpacity>
        
      </View>

      <View style={styles.bar} />

      <View style={styles.buttonContainer}>
        <TouchableOpacity
          style={styles.button}
          onPress={() => resetDeviceID()}
        >
          <Icon name="phone-portrait-outline" size={iconSize} style={styles.icon} />
          <Text style={styles.buttonText}>Reset DeviceID</Text>
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
  );
}

export default SettingsScreen;