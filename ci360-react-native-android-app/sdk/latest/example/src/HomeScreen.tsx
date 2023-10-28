
import React from 'react';
import { ScrollView, StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import Icon from 'react-native-vector-icons/Ionicons';

const iconSize = 24;
const HomeScreen = ({ navigation }) => {
  return (
    <ScrollView>
      <View style={styles.container}>
        <Text style={styles.title}>Home Screen</Text>
        <View style={styles.bar} />
        <View style={styles.buttonContainer}>
          <TouchableOpacity
            style={styles.button}
            onPress={() => navigation.navigate('Profile')}
          >
            <Icon name="person" size={iconSize} style={styles.icon} ></Icon>
            <Text style={styles.buttonText}>Profile</Text>
          </TouchableOpacity>
        </View>
        <View style={styles.bar} />
        <View style={styles.buttonContainer}>
          <TouchableOpacity
            style={styles.button}
            onPress={() => navigation.navigate('Notifications')}
          >
            <Icon name="mail-unread-outline" size={iconSize} style={styles.icon} ></Icon>
            <Text style={styles.buttonText}>Notifications</Text>
          </TouchableOpacity>
          <TouchableOpacity
            style={styles.button}
            onPress={() => navigation.navigate('Content')}
          >
            <Icon name="document-text-outline" size={iconSize} style={styles.icon} ></Icon>
            <Text style={styles.buttonText}>Content</Text>
          </TouchableOpacity>
          <TouchableOpacity
            style={styles.button}
            onPress={() => navigation.navigate('Search')}
          >
            <Icon name="search-outline" size={iconSize} style={styles.icon} ></Icon>
            <Text style={styles.buttonText}>Search</Text>
          </TouchableOpacity>
          <TouchableOpacity
            style={styles.button}
            onPress={() => navigation.navigate('Settings')}
          >
            <Icon name="settings-outline" size={iconSize} style={styles.icon} ></Icon>
            <Text style={styles.buttonText}>Settings</Text>
          </TouchableOpacity>

        </View>
        <View style={styles.bar} />
        <View style={styles.buttonContainer}>
          <TouchableOpacity
            style={styles.button}
            onPress={() => navigation.navigate('CI360')}
          >
            <Icon name="extension-puzzle-outline" size={iconSize} style={styles.icon} ></Icon>
            <Text style={styles.buttonText}>Initialize CI360</Text>
          </TouchableOpacity>
        </View>
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
    marginTop: 20
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
    padding: 10
  },
  buttonText: {
    fontSize: 24,
    marginLeft: 10,
    color: '#333'
  },
  icon: {
    color: '#333',
    marginRight: 10
  }
});

export default HomeScreen;