import React, { useState, useEffect } from 'react';
import { View, Text, NativeEventEmitter, Platform } from 'react-native';
import { WebView } from 'react-native-webview'; // Correct import for WebView
import { loadSpotData, registerSpotViewable, registerSpotClicked, AdDelegateEvent, Constants } from 'mobile-sdk-react-native';

let iOSMessagingEvent: NativeEventEmitter;
if (Platform.OS === 'ios') {
    iOSMessagingEvent = new NativeEventEmitter(AdDelegateEvent);
}

const addDataOnlySpotExample: React.FC = () => {
    const [spotData, setSpotData] = useState<string>('');
    const spotId = 'snzrle_data_spot'; // The mobile spot ID defined in your tenant

    useEffect(() => {
        // Fetch spot data and register it as viewable
        const fetchSpotData = async () => {
            try {
                const data = await loadSpotData(spotId, null); // Fetch data without attributes
                setSpotData(data);
                registerSpotViewable(spotId); // Register as viewable once data is fetched
            } catch (error) {
                console.error('Error loading spot data:', error);
            }
        };
        fetchSpotData();

        // Set up event listeners similar to Inline Spot (assuming similar events could be emitted)
        if (Platform.OS === 'ios') {
            const adLoadedListener = iOSMessagingEvent.addListener(Constants.AD_LOADED, (event: any) => {
                if (event === 'TYPE_DATA_ONLY_SPOT') { // Hypothetical event type; adjust as needed
                    console.log('Data Only Spot data is loaded.');
                }
            });

            const adDefaultLoadedListener = iOSMessagingEvent.addListener(Constants.AD_DEFAULT_LOADED, (event: any) => {
                if (event === 'TYPE_DATA_ONLY_SPOT') { // Hypothetical event type; adjust as needed
                    console.log('Data Only Spot returned default content.');
                }
            });

            return () => {
                adLoadedListener.remove();
                adDefaultLoadedListener.remove();
            };
        }
    }, []);

    return (
        <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
            {spotData ? (
                <WebView
                    source={{ html: spotData }}
                    style={{ height: 250, width: 300, margin: 25 }} // Matches InlineAdView styling
                    onTouchStart={() => registerSpotClicked(spotId)} // Register click event
                />
            ) : (
                <Text>Loading Data Only Spot...</Text>
            )}
        </View>
    );
};

export default addDataOnlySpotExample;