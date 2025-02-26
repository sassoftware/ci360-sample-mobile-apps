import React, { useState, useEffect } from 'react';
import { View, Text, NativeEventEmitter, Platform } from 'react-native';
import { loadSpotData, registerSpotViewable, registerSpotClicked, AdDelegateEvent, Constants } from 'mobile-sdk-react-native';
import JsonCreative from '../models/JsonCreative'; // Adjust path as needed
import JsonCreativeView from '../components/JsonCreativeView'; // Adjust path as needed

let iOSMessagingEvent: NativeEventEmitter;
if (Platform.OS === 'ios') {
    iOSMessagingEvent = new NativeEventEmitter(AdDelegateEvent);
}

const addDataOnlySpotExample: React.FC = () => {
    const [jsonSpotData, setJsonSpotData] = useState<JsonCreative | null>(null);
    const spotId = 'snzrle_json_spot'; // The mobile spot ID for JSON content defined in your tenant

    useEffect(() => {
        // Fetch spot data and register it as viewable
        const fetchSpotData = async () => {
            try {
                const data = await loadSpotData(spotId, null); // Fetch JSON data without attributes
                const jsonCreative = new JsonCreative(data); // Parse JSON into JsonCreative object
                setJsonSpotData(jsonCreative);
                registerSpotViewable(spotId); // Register as viewable once data is fetched
            } catch (error) {
                console.error('Error loading JSON spot data:', error);
            }
        };
        fetchSpotData();

        // Set up event listeners similar to Inline Spot (assuming similar events could be emitted)
        if (Platform.OS === 'ios') {
            const adLoadedListener = iOSMessagingEvent.addListener(Constants.AD_LOADED, (event: any) => {
                if (event === 'TYPE_DATA_ONLY_SPOT') { // Hypothetical event type; adjust as needed
                    console.log('Data Only Spot (JSON) data is loaded.');
                }
            });

            const adDefaultLoadedListener = iOSMessagingEvent.addListener(Constants.AD_DEFAULT_LOADED, (event: any) => {
                if (event === 'TYPE_DATA_ONLY_SPOT') { // Hypothetical event type; adjust as needed
                    console.log('Data Only Spot (JSON) returned default content.');
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
            {jsonSpotData ? (
                <JsonCreativeView
                    spotId={spotId}
                    creative={jsonSpotData}
                    registerSpotClicked={registerSpotClicked} // Pass the click registration function
                    style={{ height: 250, width: 300, margin: 25 }} // Matches InlineAdView styling
                />
            ) : (
                <Text>Loading JSON Creative Spot...</Text>
            )}
        </View>
    );
};

export default addDataOnlySpotExample;