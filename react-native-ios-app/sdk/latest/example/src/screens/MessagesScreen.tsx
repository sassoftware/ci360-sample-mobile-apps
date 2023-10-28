import * as React from 'react';
import { View, TextInput, ScrollView, StyleSheet } from 'react-native';
import { addAppEvent } from 'mobile-sdk-react-native';
import CustomButton from '../components/CustomButton';

export default function MessagesScreen() {
  const [smallMsg, setSmallMsg] = React.useState('smInApp_Event_RN_WW')
  const [largeMsg, setLargeMsg] = React.useState('lgInApp_Event_RN_WW');

  return (
    <ScrollView>
      <View style={styles.container}>
        <View style={styles.spot}>
          <TextInput style={styles.textInput} onChangeText={setSmallMsg} value={smallMsg}/>
          <CustomButton title='Send Small In-App' width={{width: 200}} onPress={() => {
            addAppEvent(smallMsg, null);
          }} />
        </View>
        <View style={styles.spacer} />
        <View style={styles.spot}>
          <TextInput style={styles.textInput} onChangeText={setLargeMsg} value={largeMsg}/>
          <CustomButton title='Send Large In-App' width={{width: 200}} onPress={() => {
            addAppEvent(largeMsg, null);
          }} />
        </View>
      </View>
  </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    paddingTop: 20
  },
  spot: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'space-evenly',
    width: 300,
    paddingVertical: 20,

    borderWidth: 1,
    borderColor: 'light-gray',
    borderRadius: 10
  },
  textInput: {
    height: 40,
    width: 200,
    margin: 5,
    borderWidth: 1,
    padding: 5,
  },
  spacer: {
    height: 20
  }
});
