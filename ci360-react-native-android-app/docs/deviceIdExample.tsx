import React, { useState, useEffect } from 'react';
import { View, Text, Platform } from 'react-native';
import { getDeviceID } from 'mobile-sdk-react-native';

const DeviceIDExample: React.FC = () => {
	const [DeviceID, setDeviceID] = useState<string>('');

	useEffect(() => {
	    getDeviceID((DeviceID: string) => {
	        setDeviceID(DeviceID);
	    });
	}, []);

	return (
	 <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
	     <Text>Device ID: {DeviceID}</Text>
	 </View>
	);
};

export default DeviceIDExample;