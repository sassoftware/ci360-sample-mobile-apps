import * as React from 'react';

import { createNativeStackNavigator} from '@react-navigation/native-stack';
import LoginScreen from './LoginScreen';
import DetailsScreen from './DetailsScreen';

const Stack = createNativeStackNavigator();

export default function LoginStack() {
    return (
            <Stack.Navigator
            screenOptions={{
                headerShown: true
            }}>
                <Stack.Screen name="Login" component={LoginScreen} />
                <Stack.Screen name="Details" component={DetailsScreen} />
            </Stack.Navigator>
    );
}


