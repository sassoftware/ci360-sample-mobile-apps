import React, { useState, useEffect } from 'react';
import {
  StyleSheet,
  View,
  ScrollView,
  Text,
  TextInput,
  ActivityIndicator,
  TouchableOpacity,
  Platform,
} from 'react-native';
import { WebView } from 'react-native-webview';
import Toast from 'react-native-simple-toast';
import * as MobileSdk from 'mobile-sdk-react-native';
import CustomButton from '../components/CustomButton';
import {
  getCi360Settings,
  subscribeCi360Settings,
} from '../services/Ci360SettingsStore';
import {
  initializeVisitor,
  sendEventsForVisitor,
  sendEventsForKnownUser,
  attachIdentity,
  detachIdentity,
  fetchSpotContent,
  type SseConfig,
  type Ci360Event,
  type IdType,
} from '../services/Ci360SseService';

// ─── Spot metadata type ──────────────────────────────────────────────────────
interface SpotMeta {
  spotId: string;
  spotKey: string;
  taskId: string;
  creativeId: string;
  hasContent: boolean;
  channelType: string;
  errorMsg: string | null;
  rawBody: string;
}

/** Inject a proper mobile viewport + CSS reset so any spot HTML renders cleanly */
function wrapSpotHtml(content: string): string {
  return `<!DOCTYPE html>
<html><head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1"/>
  <style>
    *{box-sizing:border-box;margin:0;padding:0}
    body{font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',sans-serif;background:#fff;padding:8px;word-wrap:break-word}
    img{max-width:100%;height:auto;display:block;margin:auto}
    a{color:#0378cd;text-decoration:none}
    table{width:100%;border-collapse:collapse}
    .ci360-btn{display:inline-block;padding:10px 20px;background:#0378cd;color:#fff;border-radius:6px;text-align:center;cursor:pointer}
  </style>
</head><body>${content}</body>
</html>`;
}

// ─── Constants (seeded from SASCollector.properties values) ───────────────────
const DEFAULT_LOAD_URI = 'SASCIApp/serverSideEvents';
const DEFAULT_KNOWN_USER_URI = 'SASCIApp/serverSideEvents/knownUser';
const DEFAULT_SPOT_ID = 'gp_serversidecontent';
const DEFAULT_SPOT_ID_TYPE = '_ci360_id';
const buildDefaultSpotPath = (gatewayHost: string, externalTenantId: string): string =>
  gatewayHost.trim() && externalTenantId.trim()
    ? `${gatewayHost.replace(/\/$/, '')}/t/content/${externalTenantId}/id_type={idType}/id_value={idValue}/spotId={spotId}`
    : '';

// ─── Component ────────────────────────────────────────────────────────────────
const ServerSideEventsScreen: React.FC = () => {
  // Config
  const [gatewayHost,      setGatewayHost]      = useState('');
  const [externalTenantId, setExternalTenantId] = useState('');
  const [sdkAppId,         setSdkAppId]         = useState('');
  const [bearerToken,      setBearerToken]      = useState('');

  // SDK correlation IDs (used for session augmentation)
  const [sdkSessionId, setSdkSessionId] = useState('');
  const [sdkLoadId,    setSdkLoadId]    = useState('');
  const [idsLoading,   setIdsLoading]   = useState(true);

  // Visitor state
  const [visitorId,       setVisitorId]       = useState('');
  const [visitorLoading,  setVisitorLoading]  = useState(false);

  // Event fields
  const [loadEventUri, setLoadEventUri] = useState(DEFAULT_LOAD_URI);
  const [augmentSession, setAugmentSession] = useState(false);
  const [eventLoading, setEventLoading] = useState(false);

  // Identity fields
  const [idType,           setIdType]           = useState<IdType>('customer_id');
  const [idValue,          setIdValue]          = useState('');
  const [identityLoading,  setIdentityLoading]  = useState(false);

  // Known-user event fields
  const [knownEventUri, setKnownEventUri] = useState(DEFAULT_KNOWN_USER_URI);
  const [knownEventLoading, setKnownEventLoading] = useState(false);

  // Spot content fields
  const [spotId, setSpotId] = useState(DEFAULT_SPOT_ID);
  const [spotIdentityType, setSpotIdentityType] = useState(DEFAULT_SPOT_ID_TYPE);
  const [spotIdentityValue, setSpotIdentityValue] = useState('');
  const [spotHtml, setSpotHtml] = useState('');
  const [spotMeta, setSpotMeta] = useState<SpotMeta | null>(null);
  const [spotEventSent, setSpotEventSent] = useState<'none' | 'viewable' | 'clicked'>('none');
  const [spotLoading, setSpotLoading] = useState(false);

  // Response / error display
  const [lastResponse, setLastResponse] = useState<string>('');
  const [lastError,    setLastError]    = useState<string>('');

  // ── SDK ID fetching ──────────────────────────────────────────────────────────
  const fetchSdkId = async (
    names: string[],
    setter: (v: string) => void
  ): Promise<string> => {
    const sdk = MobileSdk as unknown as Record<string, unknown>;
    for (const name of names) {
      const fn = sdk[name];
      if (typeof fn !== 'function') { continue; }
      try {
        return await new Promise<string>((resolve) => {
          (fn as (cb: (v: string) => void) => void)((v) => {
            setter(v ?? '');
            resolve(v ?? '');
          });
        });
      } catch { /* try next */ }
    }
    setter('');
    return '';
  };

  useEffect(() => {
    (async () => {
      await fetchSdkId(['getSessionID', 'getSessionId'], setSdkSessionId);
      await fetchSdkId(['getLoadID',    'getLoadId'],    setSdkLoadId);
      setIdsLoading(false);
    })();
  }, []);

  useEffect(() => {
    const initial = getCi360Settings();
    setGatewayHost(initial.gatewayHost);
    setExternalTenantId(initial.externalTenantId);
    setSdkAppId(initial.appId);

    return subscribeCi360Settings(({ gatewayHost: gateway, externalTenantId: tenantId, appId }) => {
      setGatewayHost(gateway);
      setExternalTenantId(tenantId);
      setSdkAppId(appId);
    });
  }, []);

  useEffect(() => {
    if (spotIdentityType === DEFAULT_SPOT_ID_TYPE && !spotIdentityValue.trim() && visitorId.trim()) {
      setSpotIdentityValue(visitorId.trim());
    }
  }, [visitorId, spotIdentityType, spotIdentityValue]);

  // ── Helpers ──────────────────────────────────────────────────────────────────
  const buildConfig = (): SseConfig => ({
    gatewayHost:      gatewayHost.trim(),
    externalTenantId: externalTenantId.trim(),
    bearerToken:      bearerToken.trim(),
  });

  const hasBaseConfig = (): boolean => {
    if (!gatewayHost.trim()) {
      Toast.show('Enter External Gateway Host', Toast.SHORT);
      return false;
    }
    if (!externalTenantId.trim()) {
      Toast.show('Enter External Tenant ID', Toast.SHORT);
      return false;
    }
    if (!bearerToken.trim()) {
      Toast.show('Enter Bearer Token', Toast.SHORT);
      return false;
    }
    return true;
  };

  const parseSpotResponse = (body: string, resolvedSpotId: string): { html: string; meta: SpotMeta } => {
    const base: SpotMeta = {
      spotId: resolvedSpotId,
      spotKey: resolvedSpotId,
      taskId: '',
      creativeId: '',
      hasContent: false,
      channelType: '',
      errorMsg: null,
      rawBody: body,
    };
    if (!body.trim()) {
      return { html: '', meta: base };
    }
    try {
      const decoded = JSON.parse(body) as unknown;
      // Handle { contents: [...] } envelope (CI360 Content Request API response)
      const unwrapped =
        decoded !== null &&
        typeof decoded === 'object' &&
        !Array.isArray(decoded) &&
        Array.isArray((decoded as Record<string, unknown>).contents)
          ? ((decoded as Record<string, unknown>).contents as unknown[])[0]
          : decoded;
      const first = Array.isArray(unwrapped) ? unwrapped[0] : unwrapped;
      if (typeof first === 'string') {
        return { html: first, meta: { ...base, hasContent: Boolean(first) } };
      }
      if (first && typeof first === 'object') {
        const r = first as Record<string, unknown>;
        const content = String(r.content ?? r.creative ?? r.html ?? '');
        return {
          html: content,
          meta: {
            spotId: String(r.spot_id ?? r.spotId ?? resolvedSpotId),
            spotKey: String(r.spot_key ?? r.spotKey ?? resolvedSpotId),
            taskId: String(r.task_id ?? r.taskId ?? ''),
            creativeId: String(r.creative_id ?? r.creativeId ?? ''),
            hasContent: Boolean(content),
            channelType: String(r.channel_type ?? r.channelType ?? ''),
            errorMsg: (r.error_msg as string | null) ?? null,
            rawBody: body,
          },
        };
      }
      return { html: body, meta: { ...base, hasContent: Boolean(body) } };
    } catch {
      return { html: body, meta: { ...base, hasContent: Boolean(body) } };
    }
  };

  const spotEndpointPreview = buildDefaultSpotPath(gatewayHost, externalTenantId);

  const showResponse = (obj: unknown) => {
    setLastError('');
    setLastResponse(JSON.stringify(obj, null, 2));
  };

  const showError = (err: unknown) => {
    const msg = err instanceof Error ? err.message : String(err);
    setLastError(msg);
    setLastResponse('');
    Toast.show(msg, Toast.SHORT);
  };

  const buildLoadEvent = (uri: string, extra: Partial<Ci360Event> = {}): Ci360Event => ({
    eventName:  'load',
    channel:    'mobile',
    uri:        uri.trim() || DEFAULT_LOAD_URI,
    clientTime: new Date().toISOString(),
    mobile: {
      appId:    sdkAppId || 'unknown_app',
      platform: Platform.OS === 'ios' ? 'iOS' : 'Android',
    },
    ...extra,
  });

  // ── Actions ──────────────────────────────────────────────────────────────────

  /** GET /t/events/i/{tenantId} */
  const handleGetVisitor = async () => {
    if (!hasBaseConfig()) {
      return;
    }
    setVisitorLoading(true);
    try {
      const result = await initializeVisitor(buildConfig());
      setVisitorId(result.visitorId);
      showResponse(result);
      Toast.show(`Visitor ID: ${result.visitorId.substring(0, 12)}…`, Toast.SHORT);
    } catch (err) {
      showError(err);
    } finally {
      setVisitorLoading(false);
    }
  };

  /** POST /t/events/e/{tenantId}/{visitorId}  (load event) */
  const handleSendLoadEvent = async () => {
    if (!hasBaseConfig()) {
      return;
    }
    if (!visitorId) {
      Toast.show('Get a Visitor ID first', Toast.SHORT);
      return;
    }
    setEventLoading(true);
    try {
      const extra: Partial<Ci360Event> =
        augmentSession && sdkSessionId && sdkLoadId
          ? { sessionId: sdkSessionId, loadId: sdkLoadId }
          : {};
      const event = buildLoadEvent(loadEventUri, extra);
      const result = await sendEventsForVisitor(buildConfig(), visitorId, [event]);
      showResponse(result);
      Toast.show('Load event sent', Toast.SHORT);
    } catch (err) {
      showError(err);
    } finally {
      setEventLoading(false);
    }
  };

  /** POST /t/events/e/{tenantId}/id_type=…/id_value=…  (load event for known user) */
  const handleSendKnownUserEvent = async () => {
    if (!hasBaseConfig()) {
      return;
    }
    if (!idValue.trim()) {
      Toast.show('Enter an Identity Value first', Toast.SHORT);
      return;
    }
    setKnownEventLoading(true);
    try {
      const event = buildLoadEvent(knownEventUri);
      const result = await sendEventsForKnownUser(buildConfig(), idType, idValue.trim(), [event]);
      showResponse(result);
      Toast.show('Known-user event sent', Toast.SHORT);
    } catch (err) {
      showError(err);
    } finally {
      setKnownEventLoading(false);
    }
  };

  /** POST /t/events/d/{tenantId}/{visitorId}/id_type=…/id_value=… */
  const handleAttachIdentity = async () => {
    if (!hasBaseConfig()) {
      return;
    }
    if (!visitorId) {
      Toast.show('Get a Visitor ID first', Toast.SHORT);
      return;
    }
    if (!idValue.trim()) {
      Toast.show('Enter an Identity Value', Toast.SHORT);
      return;
    }
    setIdentityLoading(true);
    try {
      const result = await attachIdentity(buildConfig(), visitorId, idType, idValue.trim());
      showResponse(result);
      Toast.show('Identity attached', Toast.SHORT);
    } catch (err) {
      showError(err);
    } finally {
      setIdentityLoading(false);
    }
  };

  /** DELETE /t/events/d/{tenantId}/{visitorId} */
  const handleDetachIdentity = async () => {
    if (!hasBaseConfig()) {
      return;
    }
    if (!visitorId) {
      Toast.show('Get a Visitor ID first', Toast.SHORT);
      return;
    }
    setIdentityLoading(true);
    try {
      const result = await detachIdentity(buildConfig(), visitorId);
      showResponse(result);
      Toast.show('Identity detached', Toast.SHORT);
    } catch (err) {
      showError(err);
    } finally {
      setIdentityLoading(false);
    }
  };

  const handleFetchSpotContent = async () => {
    if (!hasBaseConfig()) {
      return;
    }
    if (!spotId.trim()) {
      Toast.show('Enter Spot ID', Toast.SHORT);
      return;
    }
    if (!spotIdentityType.trim()) {
      Toast.show('Enter Spot Identity Type', Toast.SHORT);
      return;
    }

    const idValue = spotIdentityValue.trim() || (spotIdentityType.trim() === DEFAULT_SPOT_ID_TYPE ? visitorId.trim() : '');
    if (!idValue) {
      Toast.show('Enter Spot Identity Value (or get Visitor ID first)', Toast.SHORT);
      return;
    }

    setSpotLoading(true);
    setSpotEventSent('none');
    try {
      const result = await fetchSpotContent(
        buildConfig(),
        spotIdentityType.trim(),
        idValue,
        spotId.trim()
      );
      const { html, meta } = parseSpotResponse(result.body, spotId.trim());
      setSpotHtml(html);
      setSpotMeta(meta);
      showResponse({
        status: result.status,
        contentType: result.contentType,
        spotId: meta.spotId,
        spotKey: meta.spotKey,
        taskId: meta.taskId,
        creativeId: meta.creativeId,
        channelType: meta.channelType,
        hasContent: meta.hasContent,
        errorMsg: meta.errorMsg,
        preview: result.body.slice(0, 500),
      });
      if (html) {
        // auto-fire spot_viewable after successful content load
        const cfg = buildConfig();
        const viewableEvent: Ci360Event = {
          eventName: 'spot_viewable',
          channel: 'mobile',
          uri: `SASCIApp/spot/${meta.spotKey}`,
          clientTime: new Date().toISOString(),
          mobile: { appId: sdkAppId || 'unknown_app', platform: Platform.OS === 'ios' ? 'iOS' : 'Android' },
          properties: {
            ...(meta.taskId ? { task_id: meta.taskId } : {}),
            ...(meta.creativeId ? { creative_id: meta.creativeId } : {}),
          },
        };
        try {
          if (visitorId.trim()) {
            await sendEventsForVisitor(cfg, visitorId.trim(), [viewableEvent]);
          } else if (idValue.trim() && idType) {
            await sendEventsForKnownUser(cfg, idType, idValue.trim(), [viewableEvent]);
          }
          setSpotEventSent('viewable');
          Toast.show('Spot loaded · spot_viewable sent', Toast.SHORT);
        } catch {
          Toast.show('Spot loaded (viewable tracking failed)', Toast.SHORT);
        }
      } else {
        Toast.show(meta.errorMsg ?? 'No renderable content in response', Toast.SHORT);
      }
    } catch (err) {
      showError(err);
    } finally {
      setSpotLoading(false);
    }
  };

  const handleSpotClicked = async () => {
    if (!spotMeta || !hasBaseConfig()) {
      return;
    }
    const resolvedIdValue = spotIdentityValue.trim() || visitorId.trim();
    const clickEvent: Ci360Event = {
      eventName: 'spot_clicked',
      channel: 'mobile',
      uri: `SASCIApp/spot/${spotMeta.spotKey}`,
      clientTime: new Date().toISOString(),
      mobile: { appId: sdkAppId || 'unknown_app', platform: Platform.OS === 'ios' ? 'iOS' : 'Android' },
      properties: {
        ...(spotMeta.taskId ? { task_id: spotMeta.taskId } : {}),
        ...(spotMeta.creativeId ? { creative_id: spotMeta.creativeId } : {}),
      },
    };
    try {
      const cfg = buildConfig();
      if (visitorId.trim()) {
        await sendEventsForVisitor(cfg, visitorId.trim(), [clickEvent]);
      } else if (resolvedIdValue && idType) {
        await sendEventsForKnownUser(cfg, idType, resolvedIdValue, [clickEvent]);
      } else {
        Toast.show('No visitor ID or identity to track click', Toast.SHORT);
        return;
      }
      setSpotEventSent('clicked');
      Toast.show('spot_clicked sent', Toast.SHORT);
    } catch (err) {
      showError(err);
    }
  };

  // ── Render ───────────────────────────────────────────────────────────────────
  return (
    <ScrollView style={s.container} keyboardShouldPersistTaps="handled">

      {/* Header */}
      <View style={s.header}>
        <Text style={s.headerTitle}>CI360 Server-Side Events</Text>
        <Text style={s.headerSub}>Direct calls to CI360 SSE API v1</Text>
      </View>

      {/* ── 1. Configuration ─────────────────────────────────────────────────── */}
      <View style={s.card}>
        <Text style={s.cardTitle}>1 · Configuration</Text>

        <Text style={s.label}>External Gateway Host</Text>
        <TextInput
          style={s.input}
          value={gatewayHost}
          onChangeText={setGatewayHost}
          placeholder="https://ingest-training.ci360.sas.com"
          placeholderTextColor="#aaa"
          autoCapitalize="none"
          keyboardType="url"
        />

        <Text style={s.label}>External Tenant ID</Text>
        <TextInput
          style={s.input}
          value={externalTenantId}
          onChangeText={setExternalTenantId}
          placeholder="tenant.id from SASCollector.properties"
          placeholderTextColor="#aaa"
          autoCapitalize="none"
        />

        <Text style={s.label}>Bearer Token (JWT / access token)</Text>
        <TextInput
          style={s.input}
          value={bearerToken}
          onChangeText={setBearerToken}
          placeholder="Paste static JWT or access token"
          placeholderTextColor="#aaa"
          secureTextEntry
          autoCapitalize="none"
          multiline
          numberOfLines={4}
          textAlignVertical="top"
        />
        <Text style={s.hint}>
          Obtain from CI360 › Administration › General Settings › External Access › Access Points
        </Text>
      </View>

      {/* ── 2. SDK Correlation IDs ───────────────────────────────────────────── */}
      <View style={s.card}>
        <Text style={s.cardTitle}>2 · SDK Correlation IDs</Text>
        {idsLoading ? (
          <ActivityIndicator color="#0378cd" />
        ) : (
          <>
            <Row label="Session ID" value={sdkSessionId || '(not available)'} />
            <Row label="Load ID"    value={sdkLoadId    || '(not available)'} />
          </>
        )}
        <Text style={s.hint}>
          Include these in load events to augment an existing client-side SDK session.
        </Text>
      </View>

      {/* ── 3. Initialize Visitor ────────────────────────────────────────────── */}
      <View style={s.card}>
        <Text style={s.cardTitle}>3 · Initialize Visitor</Text>
        <Text style={s.hint}>
          GET /t/events/i/{'{'}{externalTenantId || '<tenantId>'}{'}'}{'\n'}
          Generates a new anonymous visitor ID (hex, 8–128 chars).
        </Text>
        {visitorId ? <Row label="Visitor ID" value={visitorId} mono /> : null}
        <CustomButton
          title={visitorLoading ? 'Getting Visitor ID…' : 'Get Visitor ID'}
          onPress={handleGetVisitor}
          width={{ width: 280 }}
        />
      </View>

      {/* ── 4. Send Load Event (anonymous) ───────────────────────────────────── */}
      <View style={s.card}>
        <Text style={s.cardTitle}>4 · Send Load Event</Text>
        <Text style={s.hint}>
          POST /t/events/e/{'{'}{externalTenantId || '<tenantId>'}{'}'}/{'{'}{visitorId ? visitorId.substring(0, 10) + '…' : '<visitorId>'}{'}'}{'\n'}
          Sends a mobile load event. Session augmentation is optional.
        </Text>

        <Text style={s.label}>URI (screen / page identifier)</Text>
        <TextInput
          style={s.input}
          value={loadEventUri}
          onChangeText={setLoadEventUri}
          placeholder="SASCIApp/home"
          placeholderTextColor="#aaa"
          autoCapitalize="none"
        />

        {sdkSessionId && sdkLoadId ? (
          <AugmentToggle value={augmentSession} onToggle={setAugmentSession} />
        ) : null}

        <CustomButton
          title={eventLoading ? 'Sending…' : 'Send Load Event'}
          onPress={handleSendLoadEvent}
          width={{ width: 280 }}
        />
      </View>

      {/* ── 5. Identity Management ───────────────────────────────────────────── */}
      <View style={s.card}>
        <Text style={s.cardTitle}>5 · Identity Management</Text>

        <Text style={s.label}>Identity Type</Text>
        <IdTypeSelector value={idType} onChange={setIdType} />

        <Text style={s.label}>Identity Value</Text>
        <TextInput
          style={s.input}
          value={idValue}
          onChangeText={setIdValue}
          placeholder="e.g. customer123 or user@example.com"
          placeholderTextColor="#aaa"
          autoCapitalize="none"
        />

        <Text style={s.hint}>
          Attach: POST /t/events/d/…/{'{visitorId}'}/id_type={idType}/id_value={'{value}'}{'\n'}
          Detach: DELETE /t/events/d/…/{'{visitorId}'}
        </Text>

        <View style={s.buttonRow}>
          <CustomButton
            title={identityLoading ? 'Working…' : 'Attach Identity'}
            onPress={handleAttachIdentity}
            width={{ width: 175 }}
          />
          <CustomButton
            title={identityLoading ? 'Working…' : 'Detach Identity'}
            onPress={handleDetachIdentity}
            width={{ width: 175 }}
          />
        </View>
      </View>

      {/* ── 6. Send Event for Known User (no visitor ID) ─────────────────────── */}
      <View style={s.card}>
        <Text style={s.cardTitle}>6 · Send Event for Known User</Text>
        <Text style={s.hint}>
          POST /t/events/e/…/id_type={idType}/id_value={'{value}'}{'\n'}
          Sends a load event directly for a known user — no visitor ID needed.
          Uses the identity type/value from section 5.
        </Text>

        <Text style={s.label}>URI</Text>
        <TextInput
          style={s.input}
          value={knownEventUri}
          onChangeText={setKnownEventUri}
          placeholder="SASCIApp/home"
          placeholderTextColor="#aaa"
          autoCapitalize="none"
        />

        <CustomButton
          title={knownEventLoading ? 'Sending…' : 'Send Event (Known User)'}
          onPress={handleSendKnownUserEvent}
          width={{ width: 280 }}
        />
      </View>

      {/* ── 7. Spot Content From Server ─────────────────────────────────────── */}
      <View style={s.card}>
        <Text style={s.cardTitle}>7 · Spot Content From Server</Text>
        <Text style={s.hint}>
          GET /t/content/{'{'}{externalTenantId || '<tenantId>'}{'}'}/id_type={'{'}{spotIdentityType || '<idType>'}{'}'}/id_value={'{'}{spotIdentityValue || '<idValue>'}{'}'}/spotId={'{'}{spotId || '<spotId>'}{'}'}{"\n"}
          Enter all required path params from {'{}'} placeholders.
        </Text>

        <Text style={s.label}>Spot ID</Text>
        <TextInput
          style={s.input}
          value={spotId}
          onChangeText={setSpotId}
          placeholder="gp_serversidecontent"
          placeholderTextColor="#aaa"
          autoCapitalize="none"
        />

        <Text style={s.label}>Spot Identity Type</Text>
        <TextInput
          style={s.input}
          value={spotIdentityType}
          onChangeText={setSpotIdentityType}
          placeholder="_ci360_id or customer_id"
          placeholderTextColor="#aaa"
          autoCapitalize="none"
        />

        <Text style={s.label}>Spot Identity Value</Text>
        <TextInput
          style={s.input}
          value={spotIdentityValue}
          onChangeText={setSpotIdentityValue}
          placeholder="visitorId or known user id value"
          placeholderTextColor="#aaa"
          autoCapitalize="none"
        />

        {spotEndpointPreview ? (
          <Text style={s.hint}>Endpoint template: {spotEndpointPreview}</Text>
        ) : null}

        <CustomButton
          title={spotLoading ? 'Loading Spot Content…' : 'Fetch Spot Content'}
          onPress={handleFetchSpotContent}
          width={{ width: 280 }}
        />

        {(spotHtml || spotMeta?.errorMsg) ? (
          <SpotCreativeCard
            html={spotHtml}
            meta={spotMeta}
            eventStatus={spotEventSent}
            onSpotClicked={handleSpotClicked}
          />
        ) : null}
      </View>

      {/* ── Response / Error panel ───────────────────────────────────────────── */}
      {lastResponse ? (
        <View style={[s.card, s.responseCard]}>
          <Text style={s.cardTitle}>Last Response</Text>
          <Text style={s.responseText}>{lastResponse}</Text>
        </View>
      ) : null}

      {lastError ? (
        <View style={[s.card, s.errorCard]}>
          <Text style={s.cardTitle}>Error</Text>
          <Text style={s.errorText}>{lastError}</Text>
          <ErrorHint error={lastError} />
        </View>
      ) : null}

      {/* ── API flow docs ────────────────────────────────────────────────────── */}
      <View style={[s.card, s.docsCard]}>
        <Text style={s.cardTitle}>API Flow Reference</Text>
        <Text style={s.docsText}>
          {'Step 1 · '}GET /t/events/i/{'{tenantId}'}      → visitorId{'\n'}
          {'Step 2 · '}POST /t/events/e/{'{tenantId}'}/{'{visitorId}'}  → send load event{'\n'}
          {'Step 3 · '}POST /t/events/d/…/id_type=…/id_value=… → attach identity{'\n'}
          {'Step 4 · '}Continue sending events (now linked to known user){'\n'}
          {'Step 5 · '}DELETE /t/events/d/{'{tenantId}'}/{'{visitorId}'}  → detach identity{'\n'}
          {'Step 6 · '}GET /t/content/{'{tenantId}'}/id_type={'{idType}'}/id_value={'{idValue}'}/spotId={'{spotId}'}{'\n'}
          {'Step 7 · '}Render spot HTML in WebView{'\n\n'}
          {'Format: '}application/x-ndjson (one JSON object per line, max 15)
        </Text>

      </View>
      <View style={s.spacer} />
    </ScrollView>
  );
};

// ─── Small helper components ──────────────────────────────────────────────────

const Row: React.FC<{ label: string; value: string; mono?: boolean }> = ({ label, value, mono }) => (
  <View style={s.row}>
    <Text style={s.rowLabel}>{label}:</Text>
    <Text style={[s.rowValue, mono ? s.mono : null]} numberOfLines={1} ellipsizeMode="middle">
      {value}
    </Text>
  </View>
);

const AugmentToggle: React.FC<{ value: boolean; onToggle: (v: boolean) => void }> = ({
  value,
  onToggle,
}) => (
  <View style={s.row}>
    <Text style={s.rowLabel}>Augment SDK session</Text>
    <Text
      style={[s.badge, value ? s.badgeOn : s.badgeOff]}
      onPress={() => onToggle(!value)}
    >
      {value ? 'ON' : 'OFF'}
    </Text>
  </View>
);

const ID_TYPES: IdType[] = ['customer_id', 'login_id', 'subject_id'];
const IdTypeSelector: React.FC<{ value: IdType; onChange: (v: IdType) => void }> = ({
  value,
  onChange,
}) => (
  <View style={s.chipRow}>
    {ID_TYPES.map((t) => (
      <Text
        key={t}
        style={[s.chip, value === t ? s.chipActive : null]}
        onPress={() => onChange(t)}
      >
        {t}
      </Text>
    ))}
  </View>
);

// ─── Spot Creative Card ──────────────────────────────────────────────────────

const SpotCreativeCard: React.FC<{
  html: string;
  meta: SpotMeta | null;
  eventStatus: 'none' | 'viewable' | 'clicked';
  onSpotClicked: () => void;
}> = ({ html, meta, eventStatus, onSpotClicked }) => {
  const statusColor =
    eventStatus === 'clicked' ? '#2e7d32' :
    eventStatus === 'viewable' ? '#0378cd' : '#aaa';
  const statusLabel =
    eventStatus === 'clicked' ? 'spot_clicked ✓' :
    eventStatus === 'viewable' ? 'spot_viewable ✓' : 'no event sent';

  return (
    <View style={sc.card}>
      {/* ── Header bar ───────────────────────────────────────── */}
      <View style={sc.header}>
        <View style={sc.headerLeft}>
          <Text style={sc.title} numberOfLines={1}>
            {meta?.spotKey || meta?.spotId || 'Spot Content'}
          </Text>
          {meta?.channelType ? (
            <View style={sc.badge}>
              <Text style={sc.badgeText}>{meta.channelType}</Text>
            </View>
          ) : null}
        </View>
        <View style={[sc.statusPill, { borderColor: statusColor }]}>
          <Text style={[sc.statusText, { color: statusColor }]}>{statusLabel}</Text>
        </View>
      </View>

      {/* ── Metadata chips ───────────────────────────────────── */}
      {meta && (meta.taskId || meta.creativeId) ? (
        <View style={sc.metaRow}>
          {meta.taskId ? (
            <View style={sc.metaChip}>
              <Text style={sc.metaKey}>task </Text>
              <Text style={sc.metaVal} numberOfLines={1}>{meta.taskId}</Text>
            </View>
          ) : null}
          {meta.creativeId ? (
            <View style={sc.metaChip}>
              <Text style={sc.metaKey}>creative </Text>
              <Text style={sc.metaVal} numberOfLines={1}>{meta.creativeId}</Text>
            </View>
          ) : null}
        </View>
      ) : null}

      {/* ── Error message ─────────────────────────────────────── */}
      {meta?.errorMsg ? (
        <Text style={sc.errorMsg}>{meta.errorMsg}</Text>
      ) : null}

      {/* ── Creative WebView ──────────────────────────────────── */}
      {html ? (
        <View style={sc.webviewWrap}>
          <WebView
            source={{ html: wrapSpotHtml(html) }}
            style={sc.webview}
            originWhitelist={['*']}
            scrollEnabled
            javaScriptEnabled
            domStorageEnabled
            showsVerticalScrollIndicator={false}
          />
        </View>
      ) : null}

      {/* ── Action row ───────────────────────────────────────── */}
      <View style={sc.actionRow}>
        <TouchableOpacity
          style={[sc.actionBtn, eventStatus === 'clicked' ? sc.actionBtnDone : null]}
          onPress={onSpotClicked}
          activeOpacity={0.75}
        >
          <Text style={sc.actionBtnText}>
            {eventStatus === 'clicked' ? 'Clicked ✓' : 'Register Spot Click'}
          </Text>
        </TouchableOpacity>
      </View>
    </View>
  );
};

const sc = StyleSheet.create({
  card: {
    marginTop: 12,
    borderRadius: 10,
    borderWidth: 1,
    borderColor: '#c8dff5',
    backgroundColor: '#f0f7ff',
    overflow: 'hidden',
  },
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    backgroundColor: '#0378cd',
    paddingHorizontal: 12,
    paddingVertical: 8,
  },
  headerLeft: { flexDirection: 'row', alignItems: 'center', flex: 1 },
  title: { fontSize: 12, fontWeight: '700', color: '#fff', flex: 1, marginRight: 6 },
  badge: {
    backgroundColor: 'rgba(255,255,255,0.25)',
    borderRadius: 8,
    paddingHorizontal: 6,
    paddingVertical: 2,
  },
  badgeText: { fontSize: 10, color: '#fff', fontWeight: '600' },
  statusPill: {
    borderWidth: 1,
    borderRadius: 8,
    paddingHorizontal: 8,
    paddingVertical: 3,
    backgroundColor: '#fff',
    marginLeft: 8,
  },
  statusText: { fontSize: 10, fontWeight: '700' },
  metaRow: { flexDirection: 'row', flexWrap: 'wrap', padding: 8, gap: 6 },
  metaChip: {
    flexDirection: 'row',
    backgroundColor: '#dbeeff',
    borderRadius: 6,
    paddingHorizontal: 7,
    paddingVertical: 3,
  },
  metaKey: { fontSize: 10, color: '#555', fontWeight: '600' },
  metaVal: { fontSize: 10, color: '#0378cd', maxWidth: 160 },
  errorMsg: {
    margin: 8,
    padding: 8,
    backgroundColor: '#fce4ec',
    borderRadius: 6,
    fontSize: 11,
    color: '#c62828',
  },
  webviewWrap: {
    height: 300,
    margin: 8,
    borderRadius: 8,
    overflow: 'hidden',
    borderWidth: 1,
    borderColor: '#c8dff5',
    backgroundColor: '#fff',
  },
  webview: { flex: 1, backgroundColor: 'transparent' },
  actionRow: {
    flexDirection: 'row',
    justifyContent: 'flex-end',
    padding: 8,
    paddingTop: 4,
  },
  actionBtn: {
    backgroundColor: '#0378cd',
    borderRadius: 6,
    paddingHorizontal: 14,
    paddingVertical: 8,
  },
  actionBtnDone: { backgroundColor: '#2e7d32' },
  actionBtnText: { fontSize: 12, fontWeight: '700', color: '#fff' },
});

const ErrorHint: React.FC<{ error: string }> = ({ error }) => {
  const lower = error.toLowerCase();
  let hint = '';
  if (lower.includes('401')) {
    hint = '401 Unauthorized: Bearer token is missing, expired, or invalid. Check Access Points in CI360 Administration.';
  } else if (lower.includes('403')) {
    hint = '403 Forbidden: Server-Side Events feature is not enabled for this tenant, or the token lacks permission.';
  } else if (lower.includes('404')) {
    hint = '404 Not Found: External Tenant ID is incorrect, or the gateway host is wrong.';
  } else if (lower.includes('400')) {
    hint = '400 Bad Request: Check visitor ID format (hex, 8–128 chars) or identity type/value.';
  } else if (lower.includes('413')) {
    hint = '413 Payload Too Large: More than 15 events per request is not allowed.';
  } else if (lower.includes('503') || lower.includes('502')) {
    hint = '5xx: CI360 gateway is temporarily unavailable. Retry after a short delay.';
  } else if (lower.includes('network')) {
    hint = 'Network error: Verify the gateway host is reachable from this device.';
  }
  if (!hint) { return null; }
  return <Text style={s.hintBox}>{hint}</Text>;
};

// ─── Styles ───────────────────────────────────────────────────────────────────
const s = StyleSheet.create({
  container:    { flex: 1, backgroundColor: '#f4f6f9' },
  header:       { backgroundColor: '#0378cd', padding: 16 },
  headerTitle:  { fontSize: 22, fontWeight: 'bold', color: '#fff', marginBottom: 2 },
  headerSub:    { fontSize: 13, color: '#cce4f7' },
  card: {
    margin: 12,
    marginBottom: 0,
    padding: 14,
    backgroundColor: '#fff',
    borderRadius: 8,
    borderLeftWidth: 4,
    borderLeftColor: '#0378cd',
  },
  cardTitle:    { fontSize: 14, fontWeight: '700', color: '#222', marginBottom: 8 },
  label:        { fontSize: 12, fontWeight: '600', color: '#555', marginTop: 8, marginBottom: 4 },
  input: {
    borderWidth: 1,
    borderColor: '#ddd',
    borderRadius: 4,
    paddingHorizontal: 10,
    paddingVertical: 7,
    fontSize: 12,
    color: '#222',
    backgroundColor: '#fafafa',
  },
  webviewWrap: { height: 0, overflow: 'hidden' },
  webview: { flex: 1 },
  hint:         { fontSize: 11, color: '#888', marginTop: 6, lineHeight: 16 },
  hintBox: {
    marginTop: 8,
    padding: 8,
    backgroundColor: '#fff8e1',
    borderRadius: 4,
    fontSize: 11,
    color: '#7a5c00',
    lineHeight: 16,
  },
  row:          { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', marginVertical: 4 },
  rowLabel:     { fontSize: 12, fontWeight: '600', color: '#666', flex: 1 },
  rowValue:     { fontSize: 12, color: '#0378cd', flex: 2, textAlign: 'right' },
  mono:         { fontFamily: 'monospace' },
  buttonRow:    { flexDirection: 'row', justifyContent: 'space-between', flexWrap: 'wrap' },
  chipRow:      { flexDirection: 'row', flexWrap: 'wrap', marginBottom: 4 },
  chip: {
    borderWidth: 1,
    borderColor: '#bbb',
    borderRadius: 12,
    paddingHorizontal: 10,
    paddingVertical: 5,
    marginRight: 8,
    marginTop: 4,
    fontSize: 11,
    color: '#555',
  },
  chipActive:   { borderColor: '#0378cd', backgroundColor: '#e3f0fb', color: '#0378cd', fontWeight: '700' },
  badge: {
    paddingHorizontal: 12,
    paddingVertical: 4,
    borderRadius: 10,
    fontSize: 12,
    fontWeight: '700',
    overflow: 'hidden',
  },
  badgeOn:      { backgroundColor: '#e8f5e9', color: '#2e7d32' },
  badgeOff:     { backgroundColor: '#fce4ec', color: '#c62828' },
  responseCard: { borderLeftColor: '#2e7d32' },
  responseText: { fontSize: 11, fontFamily: 'monospace', color: '#2e7d32', lineHeight: 17 },
  errorCard:    { borderLeftColor: '#c62828' },
  errorText:    { fontSize: 12, color: '#c62828', lineHeight: 17 },
  docsCard:     { borderLeftColor: '#ff9800', backgroundColor: '#fffde7' },
  docsText:     { fontSize: 11, color: '#5d4037', lineHeight: 17, fontFamily: 'monospace' },
  spacer:       { height: 32 },
});

export default ServerSideEventsScreen;
