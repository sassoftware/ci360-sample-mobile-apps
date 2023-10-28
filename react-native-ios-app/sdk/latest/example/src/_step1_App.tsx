import * as React from 'react';

import { StyleSheet, View, Text, Platform } from 'react-native';
import { multiply, InlineAdView, getSdkVersion } from 'mobile-sdk-react-native';

export default function App() {
  const [result, setResult] = React.useState<number | undefined>();
  const [sdkVersion, setSdkVersion] = React.useState<string | undefined>();

  React.useEffect(() => {
    multiply(3, 7).then(setResult);
    getSdkVersion((version: string) =>{
      setSdkVersion(version);
    });
  }, []);

  return (
    <View style={styles.container}>
      <Text>Result: {result}</Text>
      <Text>{Platform.OS} sdkVersion: {sdkVersion}</Text>
      <InlineAdView spotId='snzrle_app_spot' style={styles.box} />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: '70%',
    height: 200,
  },
});

