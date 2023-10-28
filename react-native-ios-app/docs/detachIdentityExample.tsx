import React, { useState } from 'react';
import { View, Button, TextInput } from 'react-native';
import { detachIdentity } from 'mobile-sdk-react-native';


const detachIdentityExample: React.FC = () => {

	const handlePress = async () => {
		try {
			await detachIdentity();
			console.log('Log-out Success');
		} catch (error) {
			console.log('Log-out Failure');
		}
	};
	   
	return (
	 <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
	   <Button title="Detach Identity" onPress={handlePress} />
	 </View>
	);
};

export default detachIdentityExample;