import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  TextInput,
  StyleSheet,
  Dimensions,
  Pressable,
} from 'react-native';
import { WebView, WebViewMessageEvent } from 'react-native-webview';
import {
  loadSpotData,
  registerSpotViewable,
  registerSpotClicked,
} from 'mobile-sdk-react-native';
import JsonCreative from '../models/JsonCreative'; // Adjust path as needed
import JsonCreativeView from '../components/JsonCreativeView'; // Adjust path as needed
import styles from './Styles/style'; // Assuming this is your existing styles file

interface SearchScreenProps {}

const SearchScreen: React.FC<SearchScreenProps> = () => {
  const [keyword, setKeyword] = useState<string>(''); // Capture search keyword
  const [jsonSpotData, setJsonSpotData] = useState<JsonCreative | null>(null); // JSON ad data
  const [htmlSpotData, setHtmlSpotData] = useState<string>(''); // HTML ad data

  // Predefined spot IDs based on keywords (you can expand this mapping)
  const adSpots: { [key: string]: { jsonSpotId: string; htmlSpotId: string } } = {
    cat: { jsonSpotId: 'CatJsonSpot', htmlSpotId: 'CatHtmlSpot' },
    dog: { jsonSpotId: 'DogJsonSpot', htmlSpotId: 'DogHtmlSpot' },
    default: { jsonSpotId: 'JsonSpot', htmlSpotId: 'HtmlSpot' }, // Fallback
  };

  // Injected JS for WebView click detection
  const injectedJS = `
    document.addEventListener('DOMContentLoaded', function() {
      document.addEventListener('click', function(e) {
        window.ReactNativeWebView.postMessage('webviewClicked');
      });
    });
  `;

  // Handle WebView click events
  const handleWebviewClicked = (event: WebViewMessageEvent, htmlSpotId: string) => {
    const message = event.nativeEvent.data;
    if (message === 'webviewClicked') {
      registerSpotClicked(htmlSpotId);
    }
  };

  // Screen dimensions for WebView
  const screenWidth = Dimensions.get('window').width - 10;
  const height = Dimensions.get('window').height / 2;

  // Load ads based on keyword
  useEffect(() => {
    const fetchAds = async () => {
      const trimmedKeyword = keyword.trim().toLowerCase();
      const { jsonSpotId, htmlSpotId } =
        adSpots[trimmedKeyword] || adSpots['default'];

      // Load JSON ad
      try {
        const jsonData = await loadSpotData(jsonSpotId, null);
        const jsonCreative = new JsonCreative(jsonData);
        setJsonSpotData(jsonCreative);
        registerSpotViewable(jsonSpotId);
      } catch (error) {
        console.error('Error loading JSON ad:', error);
      }

      // Load HTML ad
      try {
        const htmlData = await loadSpotData(htmlSpotId, null);
        setHtmlSpotData(htmlData);
        registerSpotViewable(htmlSpotId);
      } catch (error) {
        console.error('Error loading HTML ad:', error);
      }
    };

    if (keyword) {
      fetchAds();
    }
  }, [keyword]);

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Search</Text>

      {/* Search Input */}
      <TextInput
        style={localStyles.searchInput}
        placeholder="Enter keyword (e.g., 'cat' or 'dog')"
        value={keyword}
        onChangeText={setKeyword}
      />

      {/* Display Ads */}
      {jsonSpotData && (
        <JsonCreativeView
          spotId={adSpots[keyword.toLowerCase()]?.jsonSpotId || adSpots['default'].jsonSpotId}
          creative={jsonSpotData}
          registerSpotClicked={registerSpotClicked}
        />
      )}

      {htmlSpotData ? (
        <WebView
          source={{ html: htmlSpotData }}
          style={{ width: screenWidth, height: height }}
          scalesPageToFit={true}
          javaScriptEnabled={true}
          automaticallyAdjustContentInsets={true}
          injectedJavaScript={injectedJS}
          onMessage={(e) =>
            handleWebviewClicked(
              e,
              adSpots[keyword.toLowerCase()]?.htmlSpotId || adSpots['default'].htmlSpotId
            )
          }
        />
      ) : (
        <Text style={localStyles.noAdsText}>No ads to display. Enter a keyword.</Text>
      )}
    </View>
  );
};

// Local styles for search-specific components
const localStyles = StyleSheet.create({
  searchInput: {
    width: '90%',
    height: 40,
    borderWidth: 1,
    borderColor: '#ccc',
    borderRadius: 5,
    paddingHorizontal: 10,
    marginVertical: 10,
  },
  noAdsText: {
    fontSize: 16,
    color: '#666',
    marginTop: 20,
  },
});

export default SearchScreen;