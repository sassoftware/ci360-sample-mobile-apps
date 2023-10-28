import * as React from 'react';
import { SelectList } from 'react-native-dropdown-select-list';

import { StyleSheet, View, Text, TextInput, Alert, ScrollView } from 'react-native';
import type { NativeStackScreenProps } from '@react-navigation/native-stack';
import type { RootTabParameterList } from '../RootNavigation';

import {identity} from 'mobile-sdk-react-native';

import CustomButton from '../components/CustomButton';

type Props = NativeStackScreenProps<RootTabParameterList, 'Login'>;

export default function LoginScreen({ navigation }: Props) {
    const loginTypes = [
        {key:'email_id', value:'IDENTITY_TYPE_EMAIL'},
        {key:'login_id', value:'IDENTITY_TYPE_LOGIN'},
        {key:'customer_id', value:'IDENTITY_TYPE_CUSTOMER_ID'}
    ];

    const [userId, setUserId] = React.useState('');
    const [loginType, setLoginType] = React.useState('');

    React.useEffect(() => {

    });

    return (
        <ScrollView>
        <View style={styles.container}>
            <Text style={styles.title}>Please Log In</Text>
            <Text>{loginType}</Text>
            <SelectList boxStyles={{width: 200}} data={loginTypes} setSelected={setLoginType} />
            <TextInput placeholder='please enter id' style={styles.input} onChangeText={setUserId} />
            <CustomButton
                title="Log In"
                width={{width: 200}}
                onPress={async () => {
                    if(userId.length === 0 || loginType.length === 0) {
                        return;
                    }

                    const isSuccess = await identity(userId, loginType);
                    if (isSuccess) {
                        navigation.navigate('Details', {userId});
                        console.log('Log-in success')
                    } else {
                        console.log('log-in failure');
                        Alert.alert('Error', 'Log in failed', [
                                        {text: 'OK', style: 'cancel', onPress: () => {}}
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
    title: {
        fontSize: 20,
        fontWeight: 'bold',
        paddingVertical: 20,
    },
    input: {
      height: 40,
      width: 200,
      margin: 5,
      borderWidth: 1,
      padding: 5,
    },
});
