import React, { useState } from 'react';
import { View, Button, TextInput } from 'react-native';
import { addAppEvent } from 'mobile-sdk-react-native';


const addAppEventExample: React.FC = () => {
	const [customEventKey, setCustomEventKey] = React.useState<string>('');

	return (
	 <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
		<TextInput
			placeholder="Submit Custom Event"
			onChangeText={setCustomEventKey} // Capture and update the CustomEventKey state
		/>
	   <Button title="Submit Custom Event" onPress={
		   () => {
			   addAppEvent(customEventKey, null);
			}
		} />
	 </View>
	);
};

export default addAppEventExample;
