//
//#*************************************************************************************************************#
//# Application Name: SAS CI360 React Native Demo Application                                                        #
//# File Name: ServerSideContentScreen.tsx                                                                                   #
//# File Description: Server-side content screen that fetches and renders CI360 content API responses and tracks spot interactions. #
//# Author: SAS Global CX-CI                                                                                    #
//# Date: 31-October-2023       
//# Copyright  2026, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.                                   #
//# SPDX-License-Identifier: Apache-2.0                                                                         #
//#*************************************************************************************************************#
//
import React, { useState, useEffect } from 'react';
import {
  StyleSheet,
  View,
  ScrollView,
  Text,
  ActivityIndicator,
  Alert,
  TextInput,
  Switch,
} from 'react-native';
import { WebView } from 'react-native-webview';
import Toast from 'react-native-simple-toast';
import * as MobileSdk from 'mobile-sdk-react-native';
import {
  getTenantID,
  getCi360Id,
  getSessionID,
  getLoadID,
  getDeviceID,
  loadSpotData,
  registerSpotViewable,
  registerSpotClicked,
  registerSpotViewableWithIds,
  registerSpotClickedWithIds,
} from 'mobile-sdk-react-native';
import CustomButton from '../components/CustomButton';
import {
  DEFAULT_CI360_SETTINGS,
  subscribeCi360Settings,
} from '../services/Ci360SettingsStore';

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

const buildDefaultContentApiUrl = (gatewayHost: string, externalTenantId: string): string =>
  gatewayHost.trim() && externalTenantId.trim()
    ? `${gatewayHost.replace(/\/$/, '')}/t/content/${externalTenantId}/id_type=_ci360_id/id_value=/gp_serversidecontent`
    : '';

const ServerSideContentScreen: React.FC<ServerSideContentScreenProps> = () => {
  // Configuration - aligned with Flutter ref.dart
  const SPOT_ID_DEFAULT = 'gp_serversidecontent';
  const CONTENT_API_URL_DEFAULT = buildDefaultContentApiUrl(
    DEFAULT_CI360_SETTINGS.gatewayHost,
    DEFAULT_CI360_SETTINGS.externalTenantId
  );
    // 'https://i-syd.ci360.marketing/t/events/e/aee85757e600010b868fd8f5/0f3272b6369449faa75e87e70cc9c2a3'
    // 'https://i-mum.ci360.marketing/t/content/aee85757e600010b868fd8f5/id_type=_ci360_id/id_value={visitorID}/spotid=gp_serversidecontent';
  const SSE_GATEWAY_DEFAULT = DEFAULT_CI360_SETTINGS.gatewayHost;

  // State management
  const [tenantID, setTenantID] = useState<string>('');
  const [sessionID, setSessionID] = useState<string>('');
  const [loadID, setLoadID] = useState<string>('');
  const [visitorID, setVisitorID] = useState<string>('');
  const [deviceID, setDeviceID] = useState<string>('');
  const [spotId, setSpotId] = useState<string>(SPOT_ID_DEFAULT);
  const [contentApiUrl, setContentApiUrl] = useState<string>(CONTENT_API_URL_DEFAULT);
  const [sseGateway, setSseGateway] = useState<string>(SSE_GATEWAY_DEFAULT);
  const [externalTenantId, setExternalTenantId] = useState<string>(
    DEFAULT_CI360_SETTINGS.externalTenantId
  );
  const [sdkAppId, setSdkAppId] = useState<string>(DEFAULT_CI360_SETTINGS.appId);
  const [bearerToken, setBearerToken] = useState<string>('');
  const [tokenEndpoint, setTokenEndpoint] = useState<string>('https://your-tenant.ci360.marketing/api/token');
  const [clientId, setClientId] = useState<string>('');
  const [clientSecret, setClientSecret] = useState<string>('');
  const [isLoadingIDs, setIsLoadingIDs] = useState<boolean>(true);
  const [isLoadingToken, setIsLoadingToken] = useState<boolean>(false);
  const [contentHTML, setContentHTML] = useState<string>('');
  const [isLoadingContent, setIsLoadingContent] = useState<boolean>(false);
  const [spotData, setSpotData] = useState<SpotContent | null>(null);
  const [useWithIds, setUseWithIds] = useState<boolean>(false);
  const [contentSource, setContentSource] = useState<'sdk' | 'api'>('api');

  const fetchSdkId = async (
    reader: (callback: (value: string) => void) => void,
    label: string,
    setter: (value: string) => void
  ): Promise<string> => {
    try {
      return await new Promise<string>((resolve) => {
        reader((id: string) => {
          const value = id ?? '';
          console.log(`${label}:`, value);
          setter(value);
          resolve(value);
        });
      });
    } catch (error) {
      console.warn(`Failed to read ${label}:`, error);
      setter('');
      return '';
    }
  };

  // Fetch correlation IDs from Mobile SDK on mount
  useEffect(() => {
    const fetchCorrelationIDs = async () => {
      try {
        await fetchSdkId(getTenantID, 'Tenant ID', setTenantID);
        await fetchSdkId(getSessionID, 'Session ID', setSessionID);
        await fetchSdkId(getLoadID, 'Load ID', setLoadID);
        const ci360Id = await fetchSdkId(getCi360Id, 'CI360 ID', setVisitorID);
        const device = await fetchSdkId(getDeviceID, 'Device ID', setDeviceID);
        if (!ci360Id) {
          setVisitorID(device);
        }
        console.log('Visitor ID:', ci360Id || device, 'Device ID:', device, tenantID, sessionID, loadID);
        setIsLoadingIDs(false);
      } catch (error) {
        console.error('Error fetching correlation IDs:', error);
        Toast.show('Could not fetch all IDs. Continuing with available SDK data.', Toast.SHORT);
        setIsLoadingIDs(false);
      }
    };

    fetchCorrelationIDs();
  }, []);

  useEffect(() => {
    return subscribeCi360Settings(({ gatewayHost, externalTenantId: tenantId, appId }) => {
      setSseGateway(gatewayHost);
      setExternalTenantId(tenantId);
      setSdkAppId(appId);
      setContentApiUrl((currentUrl) => {
        if (!currentUrl.trim() || currentUrl === CONTENT_API_URL_DEFAULT) {
          return buildDefaultContentApiUrl(gatewayHost, tenantId);
        }
        return currentUrl;
      });
    });
  }, [CONTENT_API_URL_DEFAULT]);

  const toHexVisitorId = (value: string): string => {
    const trimmedValue = value.trim();
    if (!trimmedValue) {
      return '';
    }

    const hexOnlyValue = trimmedValue.replace(/[^0-9a-fA-F]/g, '');
    if (hexOnlyValue.length >= 8) {
      return hexOnlyValue.toLowerCase();
    }

    return Array.from(trimmedValue)
      .map((char) => char.charCodeAt(0).toString(16).padStart(2, '0'))
      .join('')
      .slice(0, 128)
      .toLowerCase();
  };

  /**
   * Calls the Content Request API server-side endpoint with correlation headers
   * and fetches personalized content for the spot.
   */
  const fetchServerSideContent = async () => {
    if (!contentApiUrl.trim()) {
      Alert.alert('Missing Config', 'Enter a Content API URL');
      return;
    }

    setIsLoadingContent(true);
    try {
      // setContentSource('api');
      // Replace id_value with CI360 ID when available, otherwise use the device ID fallback.
      let url = contentApiUrl.trim();
      const hexVisitorId = toHexVisitorId(visitorID);
      if (hexVisitorId) {
        url = url.replace(/id_value=([^/]*)/, `id_value=${hexVisitorId}`);
        // url = url.replace(/id_value=([^/]*)/, `id_value=`);
      }
      // if (spotId.trim()) {
      //   url = url.replace(
      //     /(\/id_value=[^/]+\/)([^/?#]+)/,
      //     `$1${encodeURIComponent(spotId.trim())}`
      //   );
      // }
      const safeUrl = url.replace(/\[/g, '%5B').replace(/\]/g, '%5D');

      console.log('Fetching content from:', safeUrl);

      const headers: Record<string, string> = {
        Accept: 'application/json',
      };
      if (sessionID.trim()) {
        headers['X-CI360-Session-ID'] = sessionID.trim();
      }
      if (loadID.trim()) {
        headers['X-CI360-Load-ID'] = loadID.trim();
      }
      if (deviceID.trim()) {
        headers['X-CI360-Device-ID'] = deviceID.trim();
      }
      if (bearerToken.trim()) {
        headers.Authorization = `Bearer ${bearerToken.trim()}`;
      }

      const response = await fetch(safeUrl, {
        method: 'GET',
        headers,
      });

      if (!response.ok) {
        throw new Error(`API Error: ${response.status} ${response.statusText}`);
      }

      const body = await response.text();
      let decoded: unknown;
      try {
        decoded = JSON.parse(body);
      } catch {
        setContentHTML(body);
        setSpotData(null);
        Toast.show('Raw HTML content loaded', Toast.SHORT);
        return;
      }

      const spots = Array.isArray(decoded) ? decoded : [decoded];
      const first = (spots[0] ?? {}) as Record<string, unknown>;
      const content = String(first.content ?? first.creative ?? first.html ?? '');
      const resolvedSpotId = String(first.spot_id ?? first.spotId ?? spotId);
      const resolvedSpotKey = String(first.spot_key ?? first.spotKey ?? resolvedSpotId);
      const hasContent = content.length > 0;

      const normalizedSpot: SpotContent = {
        spot_id: resolvedSpotId,
        spot_key: resolvedSpotKey,
        task_id: String(first.task_id ?? first.taskId ?? ''),
        creative_id: String(first.creative_id ?? first.creativeId ?? ''),
        request_id: String(first.request_id ?? first.requestId ?? ''),
        has_content: hasContent,
        content,
        channel_type: String(first.channel_type ?? first.channelType ?? ''),
        error_msg: (first.error_msg as string) ?? null,
      };

      setSpotData(normalizedSpot);
      if (hasContent) {
        setContentHTML(content);
        Toast.show('Content loaded successfully', Toast.SHORT);
        // Send spot_viewable event via SSE API
        await sendServerSideEvent('spot_viewable', normalizedSpot);
      } else {
        setContentHTML('');
        Toast.show('No content returned in response', Toast.SHORT);
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

  const registerSdkViewable = (spot: SpotContent) => {
    if (useWithIds && spot.task_id && spot.creative_id) {
      try {
        registerSpotViewableWithIds(
          spot.spot_id,
          spot.task_id,
          spot.creative_id,
          spot.channel_type || null,
          spot.request_id || null
        );
        return;
      } catch (error) {
        console.warn('registerSpotViewableWithIds failed, fallback to registerSpotViewable:', error);
      }
    }

    registerSpotViewable(spot.spot_id);
  };

  const registerSdkClicked = (spot: SpotContent) => {
    if (useWithIds && spot.task_id && spot.creative_id) {
      try {
        registerSpotClickedWithIds(
          spot.spot_id,
          spot.task_id,
          spot.creative_id,
          spot.channel_type || null,
          spot.request_id || null
        );
        Toast.show('Spot click registered (SDK with IDs)', Toast.SHORT);
        return;
      } catch (error) {
        console.warn('registerSpotClickedWithIds failed, fallback to registerSpotClicked:', error);
      }
    }

    registerSpotClicked(spot.spot_id);
    Toast.show('Spot click registered (SDK)', Toast.SHORT);
  };

  const fetchSdkSpotContent = async () => {
    if (!spotId.trim()) {
      Alert.alert('Missing Config', 'Enter a Spot ID');
      return;
    }

    setIsLoadingContent(true);
    setContentSource('sdk');
    setSpotData(null);
    setContentHTML('');

    try {
      const sdk = MobileSdk as unknown as Record<string, unknown>;
      let htmlContent = '';
      let taskId = '';
      let creativeId = '';
      let recGroup = '';

      if (useWithIds) {
        const withIds = sdk.loadSpotDataWithIds;
        if (typeof withIds === 'function') {
          const result = (await (
            withIds as (spot: string, attrs: Record<string, string> | null) => Promise<unknown>
          )(spotId.trim(), null)) as Record<string, unknown>;

          htmlContent = String(result.content ?? '');
          taskId = String(result.taskId ?? result.task_id ?? '');
          creativeId = String(result.creativeId ?? result.creative_id ?? '');
          recGroup = String(result.recGroup ?? result.rec_group ?? '');
        } else {
          htmlContent = await loadSpotData(spotId.trim(), null);
          Toast.show('loadSpotDataWithIds is unavailable in this SDK build. Used loadSpotData fallback.', Toast.SHORT);
        }
      } else {
        htmlContent = await loadSpotData(spotId.trim(), null);
      }

      const normalizedSpot: SpotContent = {
        spot_id: spotId.trim(),
        spot_key: spotId.trim(),
        task_id: taskId,
        creative_id: creativeId,
        request_id: '',
        has_content: htmlContent.length > 0,
        content: htmlContent,
        channel_type: recGroup,
        error_msg: null,
      };

      setSpotData(normalizedSpot);

      if (htmlContent) {
        setContentHTML(htmlContent);
        registerSdkViewable(normalizedSpot);
        Toast.show(
          useWithIds
            ? 'Content loaded via SDK (loadSpotDataWithIds)'
            : 'Content loaded via SDK (loadSpotData)',
          Toast.SHORT
        );
      } else {
        Toast.show(`No content returned for spot: ${spotId.trim()}`, Toast.SHORT);
      }
    } catch (error) {
      console.error('Error loading SDK spot content:', error);
      const errorMsg = error instanceof Error ? error.message : 'Unknown error occurred';
      Toast.show(`Failed to load SDK content: ${errorMsg}`, Toast.SHORT);
    } finally {
      setIsLoadingContent(false);
    }
  };

  /**
   * Sends events via Server-Side Events API (NDJSON format)
   * Implements spot_viewable and spot_clicked event types per CI360 SSE API spec
   */
  const sendServerSideEvent = async (
    eventType: 'spot_viewable' | 'spot_clicked',
    spot: SpotContent
  ) => {
    if (!bearerToken.trim()) {
      Toast.show('Bearer token required for SSE API. Enter token in config.', Toast.SHORT);
      return;
    }

    try {
      // Build SSE API endpoint for known user (using device ID as visitor)
      // For anonymous visitor, use: /t/events/e/{externalTenantId}/{visitorId}
      // For known user, use: /t/events/e/{externalTenantId}/id_type={idType}/id_value={idValue}
      const sseEndpoint = `${sseGateway}/t/events/e/${externalTenantId}/id_type=_ci360_id/id_value=${deviceID}`;

      // Build NDJSON event body (spot_viewable or spot_clicked)
      const event = {
        eventName: eventType,
        channel: 'mobile',
        clientTime: new Date().toISOString(),
        uri: 'SASCIApp/serverside',
        apiEventKey: `spot_${eventType}`,
        sessionId: sessionID||deviceID,
        loadId: loadID,
        mobile: {
          appId: sdkAppId || 'unknown_app',
        },
        spot: {
          id: spot.spot_id,
          key: spot.spot_key,
          taskId: spot.task_id,
          creativeId: spot.creative_id,
          recGroup: spot.channel_type || '',
          requestId: spot.request_id,
        },
      };

      // NDJSON format: each line is one JSON object
      const ndjsonBody = JSON.stringify(event);

      console.log(`Sending ${eventType} event via SSE API:`, event);

      const response = await fetch(sseEndpoint, {
        method: 'POST',
        headers: {
          Authorization: `Bearer ${bearerToken}`,
          'Content-Type': 'application/x-ndjson',
        },
        body: ndjsonBody,
      });

      if (!response.ok) {
        const error = await response.text();
        throw new Error(`SSE API error ${response.status}: ${error}`);
      }

      const result = await response.json();
      console.log(`${eventType} event sent successfully:`, result);
      Toast.show(`${eventType} event sent to SSE API`, Toast.SHORT);
    } catch (error) {
      console.error(`Error sending ${eventType} event:`, error);
      const errorMsg =
        error instanceof Error ? error.message : 'Unknown error occurred';
      Toast.show(`Failed to send event: ${errorMsg}`, Toast.SHORT);
    }
  };

  /**
   * Helper to fetch Bearer Token from CI360 access point
   * User must configure their CI360 tenant's token endpoint
   */
  const fetchBearerToken = async () => {
    if (!tokenEndpoint.trim()) {
      Alert.alert('Missing Config', 'Enter token endpoint URL');
      return;
    }
    if (!clientId.trim()) {
      Alert.alert('Missing Config', 'Enter Client ID');
      return;
    }
    if (!clientSecret.trim()) {
      Alert.alert('Missing Config', 'Enter Client Secret');
      return;
    }

    setIsLoadingToken(true);
    try {
      const response = await fetch(tokenEndpoint, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: `grant_type=client_credentials&client_id=${clientId}&client_secret=${clientSecret}`,
      });

      if (!response.ok) {
        const errorBody = await response.text();
        throw new Error(`Token endpoint returned ${response.status}: ${errorBody}`);
      }

      const data = (await response.json()) as { access_token?: string; error?: string };
      const token = data.access_token;

      if (!token) {
        throw new Error('No access_token in response. Check your CI360 configuration.');
      }

      setBearerToken(token);
      Toast.show('Bearer token obtained successfully!', Toast.SHORT);
      console.log('Bearer token acquired:', token.substring(0, 20) + '...');
    } catch (error) {
      console.error('Error fetching bearer token:', error);
      const errorMsg = error instanceof Error ? error.message : 'Unknown error occurred';
      Alert.alert(
        'Token Fetch Failed',
        `Could not fetch bearer token: ${errorMsg}`
      );
      Toast.show('Failed to fetch bearer token', Toast.SHORT);
    } finally {
      setIsLoadingToken(false);
    }
  };

  /**
   * Handles WebView click events and sends spot-clicked event via SSE API
   */
  const handleContentClicked = async () => {
    if (spotData) {
      if (contentSource === 'api') {
        await sendServerSideEvent('spot_clicked', spotData);
      } else {
        registerSdkClicked(spotData);
      }
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
              <Text style={localStyles.idLabel}>Tenant ID:</Text>
              <Text style={localStyles.idValue}>{tenantID.substring(0, 12)}...</Text>
            </View>
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

      {/* Configuration Inputs */}
      <View style={localStyles.configSection}>
        <Text style={localStyles.sectionTitle}>Configuration</Text>
        
        <View style={localStyles.inputContainer}>
          <Text style={localStyles.inputLabel}>Spot ID:</Text>
          <TextInput
            style={localStyles.textInput}
            placeholder="Enter spot ID (e.g., flutter360Spot)"
            value={spotId}
            onChangeText={setSpotId}
            placeholderTextColor="#999"
          />
        </View>

        <View style={localStyles.idRow}>
          <Text style={localStyles.idLabel}>Use loadSpotDataWithIds:</Text>
          <Switch value={useWithIds} onValueChange={setUseWithIds} />
        </View>

        <View style={localStyles.inputContainer}>
          <Text style={localStyles.inputLabel}>Content API URL:</Text>
          <TextInput
            style={localStyles.textInput}
            placeholder="Enter content API URL"
            value={contentApiUrl}
            onChangeText={setContentApiUrl}
            placeholderTextColor="#999"
          />
        </View>

        <View style={localStyles.inputContainer}>
          <Text style={localStyles.inputLabel}>SSE Gateway:</Text>
          <TextInput
            style={localStyles.textInput}
            placeholder="e.g., https://i-syd.ci360.marketing"
            value={sseGateway}
            onChangeText={setSseGateway}
            placeholderTextColor="#999"
          />
        </View>

        <View style={localStyles.inputContainer}>
          <Text style={localStyles.inputLabel}>Token Endpoint URL:</Text>
          <TextInput
            style={localStyles.textInput}
            placeholder="e.g., https://your-tenant.ci360.marketing/api/token"
            value={tokenEndpoint}
            onChangeText={setTokenEndpoint}
            placeholderTextColor="#999"
          />
        </View>

        <View style={localStyles.inputContainer}>
          <Text style={localStyles.inputLabel}>Client ID:</Text>
          <TextInput
            style={localStyles.textInput}
            placeholder="Enter Client ID from CI360"
            value={clientId}
            onChangeText={setClientId}
            placeholderTextColor="#999"
          />
        </View>

        <View style={localStyles.inputContainer}>
          <Text style={localStyles.inputLabel}>Client Secret:</Text>
          <TextInput
            style={localStyles.textInput}
            placeholder="Enter Client Secret from CI360"
            value={clientSecret}
            onChangeText={setClientSecret}
            secureTextEntry={true}
            placeholderTextColor="#999"
          />
        </View>

        <View style={localStyles.inputContainer}>
          <Text style={localStyles.inputLabel}>Bearer Token (SSE API Auth):</Text>
          <TextInput
            style={localStyles.textInput}
            placeholder="Enter JWT token for SSE API"
            value={bearerToken}
            onChangeText={setBearerToken}
            secureTextEntry={true}
            placeholderTextColor="#999"
          />
          <CustomButton
            title={isLoadingToken ? 'Fetching Token...' : 'Get Bearer Token'}
            onPress={fetchBearerToken}
            width={{ width: 250 }}
          />
        </View>
      </View>

      {/* Content Fetch Button */}
      <View style={localStyles.buttonSection}>
        <CustomButton
          title={
            isLoadingContent
              ? 'Loading SDK Spot...'
              : useWithIds
                ? 'Load SDK Spot (With IDs)'
                : 'Load SDK Spot'
          }
          onPress={fetchSdkSpotContent}
          width={{ width: 300 }}
        />
        <CustomButton
          title={isLoadingContent ? 'Loading API Content...' : 'Fetch Server-Side Content API'}
          onPress={fetchServerSideContent}
          width={{ width: 300 }}
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
            width={{ width: 300 }}
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
        <Text style={localStyles.sectionTitle}>Server-Side Events API Implementation</Text>
        <Text style={localStyles.docsText}>
          • Step 1: Fetch correlation IDs (Tenant, Session, Load, Device)
          {'\n'}
          • Step 2: Call Content Request API to get spot content
          {'\n'}
          • Step 3: Sends spot_viewable event via SSE API (NDJSON format)
          {'\n'}
          • Step 4: Render content in WebView
          {'\n'}
          • Step 5: On click, sends spot_clicked event via SSE API
          {'\n'}
          {'\n'}
          SSE Endpoints:
          {'\n'}
          POST /t/events/e/{'{'}externalTenantId{'}'}/id_type=_ci360_id/id_value={'{'}deviceID{'}'}
          {'\n'}
          {'\n'}
          Required: Bearer token for authentication
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
  configSection: {
    margin: 12,
    padding: 12,
    backgroundColor: '#fff',
    borderRadius: 8,
    borderLeftWidth: 4,
    borderLeftColor: '#ff9800',
  },
  inputContainer: {
    marginBottom: 12,
  },
  inputLabel: {
    fontSize: 12,
    fontWeight: '600',
    color: '#666',
    marginBottom: 6,
  },
  textInput: {
    borderWidth: 1,
    borderColor: '#ddd',
    borderRadius: 4,
    paddingHorizontal: 10,
    paddingVertical: 8,
    fontSize: 12,
    color: '#333',
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

//#eyJhbGciOiJSUzUxMiIsInRubSI6ImJjdDMweHoiLCJ0eXAiOiJKV1QifQ.eyJleHAiOjE3NzkyNTYwODYsImlhdCI6MTc3OTE2OTY4NiwiaXNzIjoiQ0kzNjBtaWxfYWNjZXNzUG9pbnQiLCJrIjoiZjM4NDI2ODUtMWE4MS00M2QxLTg3MzEtZTIyOGI1YjdmZTc2Iiwia3N1YiI6IjBiZTBiZjFiLTljNjUtNDA5YS05MDA4LTg1M2E2ZmM1NzI4YyIsInMiOiIyYjliZGQ3MC1hZDdhLTQ5MWMtYTM4Zi04ZjEwZjc3MDM3NjciLCJzdWIiOiI3MDk5MTllZC04NDJhLTQ1MDctYjAyNi00NTUzMDU4YjExZDUiLCJ0bm0iOiJiY3QzMHh6IiwienRvayI6ImIxZjc3OWM3LTEwOGUtNDJkZS1iMmY0LWI5OGI1MDE1ZmRiNCJ9.KCgNQgg0udQyYCLm6K9WwLRr9s3cs4-XJaXk_1ZJ5lYn5Ny-zKDUBgKWp-0gB-5IFaxId2oL9UErALi8LxIJhaWeEL8jH8GcmtVWx2zwYQ7vjI_yqWZST6jyx7-tp5zLigRWVBhMsXO1va8PfuIXybpwexrNx-zGJ0ja0WwtTYhtyhVdtmkDFjBF_z7baX4kt3XElv9wB4xDquraskEt4qke8eaWajZ0Bfk0oA0VrZTXceWlMsFuHpnV8KyuZRE46GcwEhfRaadR1jy_xMScSpplXA-F_VIca1osxOmKZeJlb9ZBARsp2T13c-FALGK4rKLkLIHwrX0BqtLfRwvAZeIHx2DKM93wdFP1F7wbVmsloL5bc4pAuMdypIUgC7BHy0Xbmint229V4Us9Nu6gr5VCYjC_4AblDjtHvIJ64LcFS_K5RijDlB1t3yDL46nJ87eDRCLo7uG_me5HdNjQZsqB8fW20-3HifjlvLJ-VhkfcuhOnhLR5cEWT7WhHu7oeupBbbdHGvu2NbzPBGnevdwrj34jXpod0khuXO5oqNsHzh-kmtBvVHv0nIt6PcC1KzsjGGSZsDch7MNyACgcBFBGI6eUwRpn7LsSy3rtgnXDd5FQp6fjvqBHDVQJby2ZYNfLe6JSyJbGwycOV_aX_MQqBJtRfDDq1ThPiSiMWdM