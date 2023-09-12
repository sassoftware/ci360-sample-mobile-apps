import React, { useState, useEffect } from 'react';
import { View, Text, Platform } from 'react-native';
import { newPage } from 'mobile-sdk-react-native';

const newPageExample: React.FC = () => {
	useEffect(() => {
		newPage('outdoor/fishing/livebait');
	}, []);
	return (
		<View style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
			<Text>{Platform.OS} newPage event sent.</Text>
		</View>
	);
};

export default newPageExample;