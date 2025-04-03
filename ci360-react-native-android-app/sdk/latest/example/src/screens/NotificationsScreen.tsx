import React from 'react';
import { View, Text } from 'react-native';
import styles from './Styles/style';

interface NotificationsScreenProps {}

const NotificationsScreen: React.FC<NotificationsScreenProps> = () => {

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Notifications</Text>
      {/* Add any other components or functionality you need */}
    </View>
  );
}

export default NotificationsScreen;