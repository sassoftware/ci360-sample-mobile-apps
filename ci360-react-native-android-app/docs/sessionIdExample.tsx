import React, { useState, useEffect } from 'react';
import { View, Text, Platform } from 'react-native';
import { getSessionID  } from 'mobile-sdk-react-native';

const sessionIdExample: React.FC = () => {
	const [sessionID, setSessionID] = useState<string>('');

	useEffect(() => {
	    getSessionID((sessionID: string) => {
	        setSessionID(sessionID);
	    });
	}, []);

	return (
	 <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
	     <Text>Session ID: {sessionID}</Text>
	 </View>
	);
};

export default sessionIdExample;