import { addAppEvent } from 'mobile-sdk-react-native';
import * as React from 'react';
import { Button, ScrollView, StyleSheet, TextInput, View } from 'react-native';

export default function MessagesScreen() {
  const [smallMsg, setSmallMsg] = React.useState('testInAppMessage');
  const [largeMsg, setLargeMsg] = React.useState('TestPushNotificationMobile');

  return (
    <ScrollView>
      <View style={styles.container}>
        <View style={styles.spot}>
          <TextInput
            style={styles.textInput}
            onChangeText={setSmallMsg}
            value={smallMsg}
          />
          <Button
            title="Send In-App message"
            width={{ width: 200 }}
            onPress={() => {
              const map2 = new Map();
              map2.set('customName', 'customName');
              map2.set('customGroupName', 'customName');
              map2.set('customRevenue', '1234');
              addAppEvent(smallMsg, map2);
            }}
          />
        </View>
        <View style={styles.spacer} />
        <View style={styles.spot}>
          <TextInput
            style={styles.textInput}
            onChangeText={setLargeMsg}
            value={largeMsg}
          />
          <Button
            title="Send Push message"
            width={{ width: 200 }}
            onPress={async () => {
              const map2 = new Map();
              map2.set('customName', 'customName');
              map2.set('customGroupName', 'customName');
              map2.set('customRevenue', 1234);
              // map2.set("pushVariable", "123")

              addAppEvent('TestPushNotificationMobile', map2);
            }}
          />
        </View>

        <View style={styles.spacer} />
      </View>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    paddingTop: 20,
  },
  spot: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'space-evenly',
    width: 300,
    paddingVertical: 20,

    borderWidth: 1,
    borderColor: 'light-gray',
    borderRadius: 10,
  },
  textInput: {
    height: 40,
    width: 200,
    margin: 5,
    borderWidth: 1,
    padding: 5,
  },
  spacer: {
    height: 20,
  },
});
