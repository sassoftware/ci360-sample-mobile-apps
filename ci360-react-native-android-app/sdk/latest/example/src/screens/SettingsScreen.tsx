import React from 'react';
import { View, Text, TextInput, TouchableOpacity } from 'react-native';
import Icon from 'react-native-vector-icons/Ionicons';
import styles from './Styles/style';
import * as MobileSdk from 'mobile-sdk-react-native';

const {
  detachIdentity,
  shutDown,
  initializeCollection,
  addAppEvent,
  resetDeviceID
} = MobileSdk;

const iconSize = 24;

interface SettingsScreenProps {
  navigation: any;
}

const SettingsScreen: React.FC<SettingsScreenProps> = ({ navigation }) => {
  const [eventName, setEventName] = React.useState('');
  const [attributeName, setAttributeName] = React.useState('');
  const [attributeValue, setAttributeValue] = React.useState('');

  return (
    <View style={styles.tabContainer}>
    
      <Text style={styles.title}>Settings</Text>

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
            shutDown();
          }}
        >
          <Icon name="close-circle" size={iconSize} style={styles.icon} />
          <Text style={styles.buttonText}>Detach & Shutdown</Text>
        </TouchableOpacity>

      </View>

      <View style={styles.bar} />

      <View style={styles.buttonContainer}>
       
        <TouchableOpacity
          style={styles.button}
          onPress={() => initializeCollection()} 
        >
          <Icon name="extension-puzzle-outline" size={iconSize} style={styles.icon} />
          <Text style={styles.buttonText}>Initialize CI360</Text>
        </TouchableOpacity>

        <TouchableOpacity
          style={styles.button}
          onPress={() => {
            shutDown();
            initializeCollection();
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