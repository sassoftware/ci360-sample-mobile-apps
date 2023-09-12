import React, { useState } from 'react';
import { View, Button, TextInput } from 'react-native';
import { addAppEvent } from 'mobile-sdk-react-native';


const addAppEventExample: React.FC = () => {
	const [customEventKey, setCustomEventKey] = React.useState<string>('');

	const handlePress = () => {
		try {
			addAppEvent(customEventKey, null);
			console.log('addApp Event Success');
		} catch (error) {
			console.log('addApp Event Failure');
		}
	};
	   
	return (
	 <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
		<TextInput
			placeholder="Submit Custom Event"
			onChangeText={setCustomEventKey} // Capture and update the userId state
		/>
	   <Button title="Send App Event" onPress={handlePress} />
	 </View>
	);
};

export default addAppEventExample;