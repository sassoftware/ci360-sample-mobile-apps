import React, { useState } from 'react';
import { View, Text, TouchableOpacity } from 'react-native';
import Icon from 'react-native-vector-icons/Ionicons';
import * as MobileSdk from 'mobile-sdk-react-native';
import styles from './Styles/style';

const { initializeCollection, shutDown } = MobileSdk;
const iconSize = 24;

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
          onPress={() => initializeCollection}
        >
          <Icon name="extension-puzzle-outline" size={iconSize} style={styles.icon} />
          <Text style={styles.buttonText}>Initialize CI360</Text>
        </TouchableOpacity>
      </View>

      <View style={styles.bar} />

      <View style={styles.buttonContainer}>
        <TouchableOpacity
          style={styles.button}
          onPress={() => shutDown()}
        >
          <Icon name="albums-outline" size={iconSize} style={styles.icon} />
          <Text style={styles.buttonText}>Disable SDK</Text>
        </TouchableOpacity>
      </View>

      <View style={styles.bar} />
    </View>
  );
};

export default HomeScreen;