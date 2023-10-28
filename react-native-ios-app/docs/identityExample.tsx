import React, { useState } from 'react';
import { View, Button, TextInput } from 'react-native';
import { identity } from 'mobile-sdk-react-native';


const identityExample: React.FC = () => {
	const [userId, setUserId] = React.useState<string>('');
	const loginType = 'IDENTITY_TYPE_CUSTOMER_ID';
	// const loginType = 'IDENTITY_TYPE_LOGIN_ID';

	const handlePress = async () => {
		try {
			await identity(userId, loginType);
			console.log('Log-in Success');
		} catch (error) {
			console.log('Log-in Failure');
		}
	};
	   
	return (
	 <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
		<TextInput
			placeholder="Enter User ID"
			onChangeText={setUserId} // Capture and update the userId state
		/>
	   <Button title="Identity" onPress={handlePress} />
	 </View>
	);
};

export default identityExample;