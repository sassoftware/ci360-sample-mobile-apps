//
//#*************************************************************************************************************#
//# Application Name: SAS CI360 React Native Demo Application                                                        #
//# File Name: HomeScreen.tsx                                                                                   #
//# File Description: Home screen that presents primary navigation actions to CI360 demo features. #
//# Author: SAS Global CX-CI                                                                                    #
//# Date: 31-October-2023       
//# Copyright  2026, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.                                   #
//# SPDX-License-Identifier: Apache-2.0                                                                         #
//#*************************************************************************************************************#
//
import React, { useState } from 'react';
import { View, Text, TouchableOpacity } from 'react-native';
import Icon from 'react-native-vector-icons/Ionicons';
import * as MobileSdk from 'mobile-sdk-react-native';
import styles from './Styles/style';

const { setAppVersionAndInitSDK } = MobileSdk;
const iconSize = 24;
const appVersion = '1.0.0';

interface HomeScreenProps {
  navigation: any; 
}

const HomeScreen: React.FC<HomeScreenProps> = ({ navigation }) => {

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Home Screen</Text>

      <View style={styles.bar} />

      <View style={styles.buttonContainer}>
        <TouchableOpacity
          style={styles.button}
          onPress={() => navigation.navigate('Profile')}
        >
          <Icon name="person" size={iconSize} style={styles.icon} />
          <Text style={styles.buttonText}>Profile</Text>
        </TouchableOpacity>
      </View>

      <View style={styles.bar} />

      <View style={styles.buttonContainer}>
        <TouchableOpacity
          style={[styles.button, { opacity: 0.5 }]}
          onPress={() => navigation.navigate('Notifications')}
          disabled={true}
        >
          <Icon name="mail-unread-outline" size={iconSize} style={styles.icon} />
          <Text style={styles.buttonText}>Notifications</Text>
        </TouchableOpacity>

        <TouchableOpacity
          style={styles.button}
          onPress={() => navigation.navigate('Content')}
        >
          <Icon name="document-text-outline" size={iconSize} style={styles.icon} />
          <Text style={styles.buttonText}>Content</Text>
        </TouchableOpacity>

        <TouchableOpacity
          style={styles.button}
          onPress={() => navigation.navigate('Search')}
        >
          <Icon name="search-outline" size={iconSize} style={styles.icon} />
          <Text style={styles.buttonText}>Search</Text>
        </TouchableOpacity>

        {/* <TouchableOpacity
          style={styles.button}
          onPress={() => navigation.navigate('ServerSideContent')}
        >
          <Icon name="cloud-download-outline" size={iconSize} style={styles.icon} />
          <Text style={styles.buttonText}>Server-Side Content</Text>
        </TouchableOpacity> */}

        <TouchableOpacity
          style={styles.button}
          onPress={() => navigation.navigate('ServerSideEvents')}
        >
          <Icon name="cloud-download-outline" size={iconSize} style={styles.icon} />
          <Text style={styles.buttonText}>SSE Events API</Text>
        </TouchableOpacity>

        <TouchableOpacity
          style={styles.button}
          onPress={() => navigation.navigate('Settings')}
        >
          <Icon name="settings-outline" size={iconSize} style={styles.icon} />
          <Text style={styles.buttonText}>Settings</Text>
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
      </View>

      <View style={styles.bar} />

      <View style={styles.buttonContainer}>
        <TouchableOpacity
          style={[styles.button, { opacity: 0.5 }]}
          onPress={() => {}}
          disabled={true}
        >
          <Icon name="albums-outline" size={iconSize} style={styles.icon} />
          <Text style={styles.buttonText}>Disable SDK (Not Available)</Text>
        </TouchableOpacity>
      </View>

      <View style={styles.bar} />
    </View>
  );
};

export default HomeScreen;