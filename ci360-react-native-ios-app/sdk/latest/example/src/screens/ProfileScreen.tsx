import React, { useContext, useState } from 'react';
import { UserContext } from '../screens/UserContent';
import { View, Text, TextInput, TouchableOpacity } from 'react-native';
import Icon from 'react-native-vector-icons/Ionicons';
import styles from './Styles/style';
import * as MobileSdk from 'mobile-sdk-react-native';
import { IDENTITY_TYPE_EMAIL } from '../../../src/Constants';

const { identity, detachIdentity } = MobileSdk;

interface ProfileScreenProps {}

const ProfileScreen: React.FC<ProfileScreenProps> = () => {
  const { isLoggedIn, setIsLoggedIn } = useContext(UserContext);
  const [email, setEmail] = useState('');
  const [emailError, setEmailError] = useState('');

  const handleSubmit = () => {
    if (!email.trim()) {
      setEmailError('Email field cannot be empty.');
      setIsLoggedIn(false);
    } else {
      setEmailError('');
      setIsLoggedIn(true);
      setEmail(email);
      identity(email, IDENTITY_TYPE_EMAIL);
    }
  };

  // Add handleLogout function
  const handleLogout = () => {
    detachIdentity(); // Call detachIdentity from MobileSdk
    setIsLoggedIn(false); // Update login state
    setEmail(''); // Clear email state
  };

  return (
    <View style={styles.tabContainer}>
      <View style={styles.iconContainer}>
        <Icon name={isLoggedIn ? 'person' : 'person-add-outline'} size={100} />
      </View>

      {isLoggedIn ? (
        <>
          <Text>Welcome Back!</Text>
          
          <TouchableOpacity
            style={styles.bigButton}
            onPress={handleLogout} // Update to use handleLogout
          >
            <Text style={styles.bigBtnText}>Logout</Text>
          </TouchableOpacity>
          
          <View style={styles.bar} />
        </>
      ) : (
        <>
          <View style={styles.bar} />
          
          <View style={styles.inputContainer}>
            <Text style={styles.inputLabel}>Email:</Text>
          </View>

          <TextInput 
            placeholder="Email"
            autoCapitalize="none"
            autoCorrect={false}
            keyboardType="email-address"
            style={styles.input} 
            onChangeText={(e) => {
              setEmail(e);
              setEmailError('');
            }}
          />
        
          <View style={styles.inputContainer}>
            <Text style={styles.inputLabel}>Password:</Text>
          </View>

          <TextInput 
            placeholder="Password"
            secureTextEntry
            keyboardType='default'
            style={styles.input} 
          />
        
          <Text style={{ color: 'red'}}>{emailError}</Text>
        
          <TouchableOpacity
            style={styles.bigButton}
            onPress={handleSubmit}
          >
            <Text style={styles.bigBtnText}>Login</Text>
          </TouchableOpacity>
        
          <View style={styles.bar} />
        </>  
      )}

      <View style={styles.indicatorContainer}>
        <Text>{isLoggedIn ? `Logged in as ${email}` : 'Logged Out'}.</Text>
      </View>
    </View>
  );
}

export default ProfileScreen;