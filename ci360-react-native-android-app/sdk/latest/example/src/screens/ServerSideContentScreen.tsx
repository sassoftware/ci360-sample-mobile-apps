import React, { useState, useEffect } from 'react';
import {
  StyleSheet,
  View,
  ScrollView,
  Text,
  ActivityIndicator,
  Alert,
} from 'react-native';
import { WebView } from 'react-native-webview';
import Toast from 'react-native-simple-toast';
import * as MobileSdk from 'mobile-sdk-react-native';
import CustomButton from '../components/CustomButton';
import styles from './Styles/style';

interface ServerSideContentScreenProps {}

interface SpotContent {
  spot_id: string;
  spot_key: string;
  task_id: string;
  creative_id: string;
  request_id: string;
  has_content: boolean;
  content: string;
  channel_type: string;
  error_msg: string | null;
}

interface ApiResponse {
  id_type: string;
  id_value: string;
  contents: SpotContent[];
}

const ServerSideContentScreen: React.FC<ServerSideContentScreenProps> = () => {
  // Configuration
  const TENANT_ID = 'snzrle'; // Replace with your tenant ID
  const API_GATEWAY = 'https://i-us.ci360.marketing'; // Replace with your gateway
  const SPOT_ID = 'a1b2c3d4-e5f6-7890-abcd-ef1234567890'; // Replace with your spot ID
  const JWT_TOKEN = 'YOUR_JWT_TOKEN_HERE'; // Replace with valid JWT

  // State management
  const [sessionID, setSessionID] = useState<string>('');
  const [loadID, setLoadID] = useState<string>('');
  const [visitorID, setVisitorID] = useState<string>('');
  const [deviceID, setDeviceID] = useState<string>('');
  const [isLoadingIDs, setIsLoadingIDs] = useState<boolean>(true);
  const [contentHTML, setContentHTML] = useState<string>('');
  const [isLoadingContent, setIsLoadingContent] = useState<boolean>(false);
  const [spotData, setSpotData] = useState<SpotContent | null>(null);

  // Fetch correlation IDs from Mobile SDK on mount
  useEffect(() => {
    const fetchCorrelationIDs = async () => {
      try {
        // Get Session ID
        await new Promise((resolve) => {
          MobileSdk.getSessionID((id: string) => {
            console.log('Session ID:', id);
            setSessionID(id);
            resolve(id);
          });
        });

        // Get Load ID (new in 1.89.1)
        await new Promise((resolve) => {
          MobileSdk.getLoadID((id: string) => {
            console.log('Load ID:', id);
            setLoadID(id);
            resolve(id);
          });
        });

        // Get Device ID for visitor context
        await new Promise((resolve) => {
          MobileSdk.getDeviceID((id: string) => {
            console.log('Device ID:', id);
            setDeviceID(id);
            // Use device ID as visitor ID for this example
            setVisitorID(id);
            resolve(id);
          });
        });

        setIsLoadingIDs(false);
      } catch (error) {
        console.error('Error fetching correlation IDs:', error);
        Toast.show('Failed to fetch correlation IDs', Toast.SHORT);
        setIsLoadingIDs(false);
      }
    };

    fetchCorrelationIDs();
  }, []);

  /**
   * Calls the Content Request API server-side endpoint with correlation headers
   * and fetches personalized content for the spot.
   */
  const fetchServerSideContent = async () => {
    if (!sessionID || !loadID || !visitorID) {
      Alert.alert('Missing IDs', 'Session ID, Load ID, or Visitor ID not initialized');
      return;
    }

    setIsLoadingContent(true);
    try {
      // Build the Content Request API URL
      const url = `${API_GATEWAY}/t/content/${TENANT_ID}/id_type=visitor_id/id_value=${visitorID}/spotid=${SPOT_ID}`;

      console.log('Fetching content from:', url);

      const response = await fetch(url, {
        method: 'GET',
        headers: {
          'Authorization': `Bearer ${JWT_TOKEN}`,
          // Pass correlation IDs as headers for server-side event tracking
          'X-CI360-Session-ID': sessionID,
          'X-CI360-Load-ID': loadID,
          'X-CI360-Device-ID': deviceID,
          'Content-Type': 'application/json',
        },
      });

      if (!response.ok) {
        throw new Error(`API Error: ${response.status} ${response.statusText}`);
      }

      const data: ApiResponse = await response.json();
      console.log('API Response:', data);

      if (data.contents && data.contents.length > 0) {
        const spot = data.contents[0];
        setSpotData(spot);

        if (spot.has_content) {
          setContentHTML(spot.content);
          Toast.show('Content loaded successfully', Toast.SHORT);

          // Send spot-requested event via SDK (happens auto server-side)
          // Send spot-viewed event explicitly since we're server-side
          sendServerSideEvent('spot-viewed', spot);
        } else {
          setContentHTML('');
          Toast.show('No content available for this spot', Toast.SHORT);
        }
      } else {
        Alert.alert('Error', data.contents?.[0]?.error_msg || 'No content returned');
      }
    } catch (error) {
      console.error('Error fetching server-side content:', error);
      const errorMsg =
        error instanceof Error ? error.message : 'Unknown error occurred';
      Toast.show(`Failed to load content: ${errorMsg}`, Toast.SHORT);
    } finally {
      setIsLoadingContent(false);
    }
  };

  /**
   * Simulates sending a server-side event through the Server-Side Events API
   * In production, this would be called from your backend via:
   * POST https://events.ci360.marketing/events/{tenantId}
   */
  const sendServerSideEvent = (eventType: string, spot: SpotContent) => {
    console.log(`Sending server-side event: ${eventType}`, {
      sessionID,
      loadID,
      spotID: spot.spot_id,
      taskID: spot.task_id,
      creativeID: spot.creative_id,
      visitorID,
    });

    // Example server-side event payload for backend:
    const eventPayload = {
      event_type: eventType, // 'spot-viewed', 'spot-clicked', etc.
      visitor_id: visitorID,
      session_id: sessionID,
      load_id: loadID,
      timestamp: new Date().toISOString(),
      spot_id: spot.spot_id,
      task_id: spot.task_id,
      creative_id: spot.creative_id,
      request_id: spot.request_id,
    };

    Toast.show(`Event sent: ${eventType}`, Toast.SHORT);
    console.log('Event payload (would send to backend):', eventPayload);
  };

  /**
   * Handles WebView click events and sends spot-clicked event
   */
  const handleContentClicked = () => {
    if (spotData) {
      sendServerSideEvent('spot-clicked', spotData);
    }
  };

  /**
   * Injected JavaScript for WebView click detection
   */
  const injectedJS = `
    document.addEventListener('click', function(e) {
      window.ReactNativeWebView.postMessage('spotClicked');
    }, true);
    true;
  `;

  return (
    <ScrollView style={localStyles.container}>
      <View style={localStyles.section}>
        <Text style={localStyles.title}>Server-Side Content Request</Text>
        <Text style={localStyles.subtitle}>
          Hybrid approach: Mobile SDK + Content Request API
        </Text>
      </View>

      {/* Correlation IDs Display */}
      <View style={localStyles.idsSection}>
        <Text style={localStyles.sectionTitle}>Correlation IDs</Text>
        {isLoadingIDs ? (
          <ActivityIndicator size="large" color="#0378cd" />
        ) : (
          <>
            <View style={localStyles.idRow}>
              <Text style={localStyles.idLabel}>Session ID:</Text>
              <Text style={localStyles.idValue}>{sessionID.substring(0, 12)}...</Text>
            </View>
            <View style={localStyles.idRow}>
              <Text style={localStyles.idLabel}>Load ID:</Text>
              <Text style={localStyles.idValue}>{loadID.substring(0, 12)}...</Text>
            </View>
            <View style={localStyles.idRow}>
              <Text style={localStyles.idLabel}>Visitor ID:</Text>
              <Text style={localStyles.idValue}>{visitorID.substring(0, 12)}...</Text>
            </View>
            <View style={localStyles.idRow}>
              <Text style={localStyles.idLabel}>Device ID:</Text>
              <Text style={localStyles.idValue}>{deviceID.substring(0, 12)}...</Text>
            </View>
          </>
        )}
      </View>

      {/* Content Fetch Button */}
      <View style={localStyles.buttonSection}>
        <CustomButton
          title={isLoadingContent ? 'Loading...' : 'Fetch Server-Side Content'}
          onPress={fetchServerSideContent}
          width={{ width: '100%' }}
        />
      </View>

      {/* Content Display */}
      {contentHTML ? (
        <View style={localStyles.contentSection}>
          <Text style={localStyles.sectionTitle}>Delivered Content</Text>
          {spotData && (
            <View style={localStyles.spotMetadata}>
              <Text style={localStyles.metaText}>
                Spot: {spotData.spot_key}
              </Text>
              <Text style={localStyles.metaText}>
                Task ID: {spotData.task_id}
              </Text>
              <Text style={localStyles.metaText}>
                Request ID: {spotData.request_id.substring(0, 12)}...
              </Text>
            </View>
          )}
          <WebView
            style={localStyles.webview}
            source={{ html: contentHTML }}
            injectedJavaScript={injectedJS}
            onMessage={(event) => {
              if (event.nativeEvent.data === 'spotClicked') {
                handleContentClicked();
              }
            }}
            startInLoadingState={true}
            renderLoading={() => (
              <ActivityIndicator
                style={localStyles.loader}
                size="large"
                color="#0378cd"
              />
            )}
          />
          <CustomButton
            title="Register Click Event"
            onPress={handleContentClicked}
            width={{ width: '100%' }}
          />
        </View>
      ) : contentHTML === '' && spotData && !spotData.has_content ? (
        <View style={localStyles.emptyState}>
          <Text style={localStyles.emptyText}>
            No content available for this spot
          </Text>
        </View>
      ) : null}

      {/* Documentation */}
      <View style={localStyles.docsSection}>
        <Text style={localStyles.sectionTitle}>How It Works</Text>
        <Text style={localStyles.docsText}>
          1. Fetch Session ID and Load ID from Mobile SDK (v1.89.1+)
          {'\n'}
          2. Call Content Request API with these IDs as correlation headers
          {'\n'}
          3. Render returned HTML content in WebView
          {'\n'}
          4. Send spot-viewed and spot-clicked events via Server-Side Events API
          {'\n'}
          5. Events are correlated server-side using Session ID + Load ID
        </Text>
      </View>
    </ScrollView>
  );
};

const localStyles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f5f5f5',
  },
  section: {
    padding: 16,
    backgroundColor: '#0378cd',
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#fff',
    marginBottom: 4,
  },
  subtitle: {
    fontSize: 14,
    color: '#e0e0e0',
  },
  idsSection: {
    margin: 12,
    padding: 12,
    backgroundColor: '#fff',
    borderRadius: 8,
    borderLeftWidth: 4,
    borderLeftColor: '#0378cd',
  },
  sectionTitle: {
    fontSize: 16,
    fontWeight: 'bold',
    marginBottom: 12,
    color: '#333',
  },
  idRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    paddingVertical: 8,
    borderBottomWidth: 1,
    borderBottomColor: '#e0e0e0',
  },
  idLabel: {
    fontSize: 12,
    fontWeight: '600',
    color: '#666',
    flex: 1,
  },
  idValue: {
    fontSize: 12,
    fontFamily: 'monospace',
    color: '#0378cd',
    flex: 1,
    textAlign: 'right',
  },
  buttonSection: {
    margin: 12,
    padding: 12,
  },
  contentSection: {
    margin: 12,
    padding: 12,
    backgroundColor: '#fff',
    borderRadius: 8,
  },
  spotMetadata: {
    marginBottom: 12,
    padding: 8,
    backgroundColor: '#f0f0f0',
    borderRadius: 4,
  },
  metaText: {
    fontSize: 11,
    color: '#666',
    marginBottom: 4,
    fontFamily: 'monospace',
  },
  webview: {
    height: 300,
    marginVertical: 12,
    borderRadius: 4,
    borderWidth: 1,
    borderColor: '#ddd',
  },
  loader: {
    flex: 1,
    justifyContent: 'center',
  },
  emptyState: {
    margin: 12,
    padding: 24,
    backgroundColor: '#fff',
    borderRadius: 8,
    alignItems: 'center',
  },
  emptyText: {
    fontSize: 14,
    color: '#999',
    textAlign: 'center',
  },
  docsSection: {
    margin: 12,
    padding: 12,
    backgroundColor: '#e3f2fd',
    borderRadius: 8,
    marginBottom: 24,
  },
  docsText: {
    fontSize: 12,
    color: '#1565c0',
    lineHeight: 18,
  },
});

export default ServerSideContentScreen;
