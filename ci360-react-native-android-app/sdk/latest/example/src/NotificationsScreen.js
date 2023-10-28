import React from 'react';
import { ScrollView, StyleSheet, Text, View } from 'react-native';

const NotificationsScreen = ({ initialParams }) => {
  console.log("Props from notification initialParams", initialParams)
  return (
    <ScrollView>
      <View style={styles.container}>
        <Text style={styles.title}>Notifications</Text>
        {/* Add any other components or functionality you need */}
      </View>
    </ScrollView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 16,
  },
});

export default NotificationsScreen;