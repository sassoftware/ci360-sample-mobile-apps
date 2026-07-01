//
//#*************************************************************************************************************#
//# Application Name: SAS CI360 React Native Demo Application                                                        #
//# File Name: ConfigScreen.tsx                                                                                   #
//# File Description: Configuration screen for tenant presets and SDK setup values such as tenant ID, app ID, and tag server. #
//# Author: SAS Global CX-CI                                                                                    #
//# Date: 31-October-2023       
//# Copyright  2026, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.                                   #
//# SPDX-License-Identifier: Apache-2.0                                                                         #
//#*************************************************************************************************************#
//
import * as MobileSdk from 'mobile-sdk-react-native';
import React, { useEffect } from 'react';
import {
  Text,
  TextInput,
  TouchableOpacity,
  View,
} from 'react-native';
import Toast from 'react-native-simple-toast';
import { SelectList } from 'react-native-dropdown-select-list';
import { updateCi360Settings } from '../services/Ci360SettingsStore';
const {
  setAppVersionAndInitSDK,
  getDeviceID,
} = MobileSdk;
import styles from './Styles/style';  

const appVersion = '1.0';

interface TenantConfig {
  tenantId: string;
  tagServer: string;
  appId: string;
}

const TENANT_PRESETS: Array<{ key: string; value: string; config: TenantConfig }> = [
  {
    key: '1',
    value: 'Test Tenant',
    config: {
      tenantId: 'xxxxxxxx',
        tagServer: 'https://<gateway_url>/t/mobile',
      appId: 'react_native_demo_app_v1',
    },
  },
  {
    key: '2',
    value: 'Development Tenant',
    config: {
      tenantId: 'xxxxxxxxxxxxxx',
      tagServer: 'https://<gateway_url>/t/mobile',
      appId: 'react_native_demo_app_v1',
    },
  }
];

interface ConfigScreenProps {
  navigation: any;
}

const ConfigScreen: React.FC<ConfigScreenProps> = ({ navigation }) => {
  const [appId, defineAppId] = React.useState('');
  const [tagServer, defineTagServer] = React.useState('');
  const [, defineDeviceID] = React.useState('');
  const [tenantID, defineTenantId] = React.useState('');
  const [selectedPresetKey, setSelectedPresetKey] = React.useState('');

  const getGatewayHostFromTagServer = (tagServerUrl: string): string => {
    try {
      const parsed = new URL(tagServerUrl.trim());
      return `${parsed.protocol}//${parsed.host}`;
    } catch {
      return tagServerUrl.trim().replace(/\/t\/mobile\/?$/, '').replace(/\/$/, '');
    }
  };

  const handleTenantPresetSelect = (key: string) => {
    setSelectedPresetKey(key);
    const preset = TENANT_PRESETS.find(p => p.key === key);
    if (preset && preset.config.tenantId) {
      defineTenantId(preset.config.tenantId);
      defineTagServer(preset.config.tagServer);
      defineAppId(preset.config.appId);
    }
  };

  const handleApplyConfig = () => {
    console.log('Executed handleApplyConfig');

    updateCi360Settings({
      externalTenantId: tenantID,
      gatewayHost: getGatewayHostFromTagServer(tagServer),
      appId,
    });

    setAppVersionAndInitSDK('1.0.0');
    console.log(
      'SDK initialized. Tenant/App/Tag values come from SASCollector.properties.',
      appId,
      tenantID,
      tagServer
    );
    Toast.show('SDK initialized. Update SASCollector.properties for tenant config.', Toast.LONG);
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
          <Text style={styles.inputLabel}>Select Tenant Preset:</Text>
        </View>
        <SelectList
          setSelected={handleTenantPresetSelect}
          data={TENANT_PRESETS.map(p => ({ key: p.key, value: p.value }))}
          save="key"
          placeholder="Choose a tenant preset..."
          boxStyles={{ marginBottom: 10, borderColor: '#ccc' }}
          dropdownStyles={{ borderColor: '#ccc' }}
          defaultOption={
            selectedPresetKey
              ? { key: selectedPresetKey, value: TENANT_PRESETS.find(p => p.key === selectedPresetKey)?.value ?? '' }
              : undefined
          }
        />

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