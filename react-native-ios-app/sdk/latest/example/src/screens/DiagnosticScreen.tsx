import * as React from 'react';
import { StyleSheet, View, Text } from 'react-native';
import type { NativeStackScreenProps } from '@react-navigation/native-stack';
import type { RootTabParameterList } from '../RootNavigation';

type Props = NativeStackScreenProps<RootTabParameterList, 'Diagnostics'>;

export default function DiagnosticScreen({route}: Props) {

  return (
    <View style={styles.container}>
      <Text style={styles.text}>The Diagnostic Screen</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center'
  },
  text: {
    textAlign: 'center',
    fontSize: 18
  }
})
