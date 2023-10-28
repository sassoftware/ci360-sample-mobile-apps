import * as React from 'react';
import type { NativeStackScreenProps } from '@react-navigation/native-stack';

import { StyleSheet, View, Text, ScrollView, Alert } from 'react-native';
import * as MobileSdk from 'mobile-sdk-react-native';
const { detachIdentity } = MobileSdk;
import CustomButton from '../components/CustomButton';
import type { RootTabParameterList } from '../RootNavigation';

type Props = NativeStackScreenProps<RootTabParameterList, 'Details'>;

export default function DetailsScreen({ navigation, route }: Props) {
    const userId = route.params.userId;

    return (
        <ScrollView>
        <View style={styles.container}>
            <View style={{padding: 30}} />
            <Text>Welcome {userId}</Text>
            <View style={{padding: 20}} />
            <CustomButton
                title='Detach Identity'
                width={{width: 150}}
                onPress={ async () => {
                    const isSuccess = await detachIdentity();
                    if (isSuccess) {
                        console.log('detach success');
                        navigation.goBack();
                    } else {
                        console.log('detach failure');
                        Alert.alert('Error', 'Detach identity failed', [
                                       {text: 'OK', style: 'cancel', onPress:() =>{}}
                                    ]);
                    }
                }} />

        </View>
        </ScrollView>
    );
};

const styles = StyleSheet.create({
    container: {
        flex: 1,
        alignItems: 'center',
        justifyContent: 'center',
      },
});
