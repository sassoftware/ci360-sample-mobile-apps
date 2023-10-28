import React, { useState, useEffect } from 'react';
import { View, Text, Platform } from 'react-native';
import { getSdkVersion } from 'mobile-sdk-react-native';

const sdkVersionExample: React.FC = () => {
	const [sdkVersion, setSdkVersion] = useState<string>('');

	useEffect(() => {
	    getSdkVersion((version: string) => {
	        setSdkVersion(version);
	    });
	}, []);

	return (
	 <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
	     <Text>{Platform.OS} SDK version: {sdkVersion}</Text>
	 </View>
	);
};

export default sdkVersionExample;