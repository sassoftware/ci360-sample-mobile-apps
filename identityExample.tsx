import React, { useState } from 'react';
import { View, Button } from 'react-native';
import { identity } from 'mobile-sdk-react-native';


const sdkVersionExample: React.FC = () => {
	const [loginType, setLoginType] = React.useState<string>('');
	const [userId, setUserId] = React.useState<string>('');

	return (
	 <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
	   <Button title="Identity" onPress={handlePress} />
	 </View>
	);
};