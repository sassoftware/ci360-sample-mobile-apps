import React from 'react';
import { ScrollView, StyleSheet, Text, View } from 'react-native';

const ContentScreen = ({ initialParams }) => {
  console.log("initialParams::::", initialParams)
  return (
    <ScrollView>
      <View style={styles.container}>
        <Text style={styles.title}>Content Page</Text>
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

export default ContentScreen;