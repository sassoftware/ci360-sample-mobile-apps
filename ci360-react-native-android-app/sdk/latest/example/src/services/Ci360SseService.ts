//
//#*************************************************************************************************************#
//# Application Name: SAS CI360 React Native Demo Application                                                        #
//# File Name: Ci360SseService.ts                                                                                   #
//# File Description: Provides typed CI360 Server-Side Events API helpers for visitor, identity, event, and content operations. #
//# Author: SAS Global CX-CI                                                                                    #
//# Date: 31-October-2023       
//# Copyright  2026, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.                                   #
//# SPDX-License-Identifier: Apache-2.0                                                                         #
//#*************************************************************************************************************#
//
/**
 * Ci360SseService
 *
 * Typed service layer for CI360 Server-Side Events API v1.
 * API reference: https://supportprod.unx.sas.com/documentation/onlinedoc/ci/ci360-apis/serverSideEvents/v1/redoc.html
 *
 * Endpoints used:
 *   GET    /t/events/i/{externalTenantId}                                          – initialize visitor
 *   POST   /t/events/e/{externalTenantId}/{visitorId}                              – send events (anonymous)
 *   POST   /t/events/e/{externalTenantId}/id_type={idType}/id_value={idValue}      – send events (known user)
 *   POST   /t/events/d/{externalTenantId}/{visitorId}/id_type={idType}/id_value={idValue} – attach identity
 *   DELETE /t/events/d/{externalTenantId}/{visitorId}                              – detach identity
 *
 * NOTE: Bearer token is entered at runtime in the demo UI and is NEVER hardcoded here.
 */

// ─── Types ────────────────────────────────────────────────────────────────────

export type IdType = 'customer_id' | 'login_id' | 'subject_id';

export type EventName =
  | 'load'
  | 'click'
  | 'submit'
  | 'cart'
  | 'cartAction'
  | 'custom'
  | 'internalSearch'
  | 'productView'
  | 'promotion'
  | 'document'
  | 'media'
  | 'spot_viewable'
  | 'spot_clicked';

export type EventChannel = 'web' | 'mobile';

export interface Ci360Event {
  eventName: EventName;
  channel: EventChannel;
  uri: string;
  clientTime?: string; // ISO 8601
  apiEventKey?: string; // required for non-system events
  sessionId?: string;
  loadId?: string;
  properties?: Record<string, string>;
  mobile?: {
    appId: string;
    platform?: string;
    platformVersion?: string;
    deviceModel?: string;
    deviceType?: string;
    deviceMfg?: string;
    screenHeight?: string;
    screenWidth?: string;
    deviceLanguage?: string;
  };
  [key: string]: unknown;
}

export interface InitVisitorResponse {
  visitorId: string;
  error: string;
}

export interface IdentityResponse {
  datahub_id?: string;
  visitor_id?: string;
  id_type?: string;
  id_value?: string;
  error: string;
}

export interface SendEventsResponse {
  error: string;
}

export interface SpotContentResponse {
  status: number;
  contentType: string;
  body: string;
}

export interface SseConfig {
  /** External gateway host, e.g. https://i-us.ci360.marketing */
  gatewayHost: string;
  /** External tenant ID from SASCollector.properties (tenant.id) */
  externalTenantId: string;
  /** Static JWT / access token – entered at runtime, never stored */
  bearerToken: string;
}

// ─── Service ──────────────────────────────────────────────────────────────────

/**
 * Build Authorization header. Trims whitespace to avoid common config errors.
 */
function authHeader(token: string): Record<string, string> {
  const t = token.trim();
  if (!t) {
    return {};
  }
  return { Authorization: `Bearer ${t}` };
}

/**
 * Serialize an array of Ci360Event objects to NDJSON (one JSON object per line).
 * Max 15 events per request per API spec.
 */
function toNdjson(events: Ci360Event[]): string {
  return events
    .slice(0, 15)
    .map((e) => JSON.stringify(e))
    .join('\n');
}

async function parseResponse<T>(response: Response): Promise<T> {
  const text = await response.text();
  if (!text) {
    return { error: 'No errors.' } as unknown as T;
  }
  try {
    return JSON.parse(text) as T;
  } catch {
    return { error: text } as unknown as T;
  }
}

// ─── Public API ───────────────────────────────────────────────────────────────

/**
 * GET /t/events/i/{externalTenantId}
 * Generate a new anonymous visitor ID.
 */
export async function initializeVisitor(
  config: SseConfig
): Promise<InitVisitorResponse> {
  const { gatewayHost, externalTenantId, bearerToken } = config;
  const url = `${gatewayHost.replace(/\/$/, '')}/t/events/i/${encodeURIComponent(externalTenantId)}`;
  
  console.log("Req response initialise visitor", url, authHeader(bearerToken))
  const response = await fetch(url, {
    method: 'GET',
    headers: {
      Accept: 'application/json',
      ...authHeader(bearerToken),
    },
  });

  const body = await parseResponse<InitVisitorResponse>(response);
  if (!response.ok) {
    throw new Error(`[${response.status}] ${body.error ?? response.statusText}`);
  }
  return body;
}

/**
 * POST /t/events/e/{externalTenantId}/{visitorId}
 * Send one or more events for an anonymous visitor (may have attached identity).
 */
export async function sendEventsForVisitor(
  config: SseConfig,
  visitorId: string,
  events: Ci360Event[]
): Promise<SendEventsResponse> {
  const { gatewayHost, externalTenantId, bearerToken } = config;
  const url = `${gatewayHost.replace(/\/$/, '')}/t/events/e/${encodeURIComponent(externalTenantId)}/${encodeURIComponent(visitorId)}`;
console.log("Req response sendevents for visitor", url, authHeader(bearerToken))
  const response = await fetch(url, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/x-ndjson',
      Accept: 'application/json',
      ...authHeader(bearerToken),
    },
    body: toNdjson(events),
  });

  const body = await parseResponse<SendEventsResponse>(response);
  if (!response.ok) {
    throw new Error(`[${response.status}] ${body.error ?? response.statusText}`);
  }
  return body;
}

/**
 * POST /t/events/e/{externalTenantId}/id_type={idType}/id_value={idValue}
 * Send events directly for a known user (no visitor ID required).
 */
export async function sendEventsForKnownUser(
  config: SseConfig,
  idType: IdType,
  idValue: string,
  events: Ci360Event[]
): Promise<SendEventsResponse> {
  const { gatewayHost, externalTenantId, bearerToken } = config;
  const url = `${gatewayHost.replace(/\/$/, '')}/t/events/e/${encodeURIComponent(externalTenantId)}/id_type=${encodeURIComponent(idType)}/id_value=${encodeURIComponent(idValue)}`;
console.log("Req response send events for known user", url, authHeader(bearerToken))
  const response = await fetch(url, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/x-ndjson',
      Accept: 'application/json',
      ...authHeader(bearerToken),
    },
    body: toNdjson(events),
  });

  const body = await parseResponse<SendEventsResponse>(response);
  if (!response.ok) {
    throw new Error(`[${response.status}] ${body.error ?? response.statusText}`);
  }
  return body;
}

/**
 * POST /t/events/d/{externalTenantId}/{visitorId}/id_type={idType}/id_value={idValue}
 * Attach a known identity to an anonymous visitor.
 * Supported idType: customer_id | login_id | subject_id
 */
export async function attachIdentity(
  config: SseConfig,
  visitorId: string,
  idType: IdType,
  idValue: string
): Promise<IdentityResponse> {
  const { gatewayHost, externalTenantId, bearerToken } = config;
  const url = `${gatewayHost.replace(/\/$/, '')}/t/events/d/${encodeURIComponent(externalTenantId)}/${encodeURIComponent(visitorId)}/id_type=${encodeURIComponent(idType)}/id_value=${encodeURIComponent(idValue)}`;
  console.log("Req response attach identity", url, authHeader(bearerToken))
  const response = await fetch(url, {
    method: 'POST',
    headers: {
      Accept: 'application/json',
      'Content-Type': 'application/json',
      ...authHeader(bearerToken),
    },
    body: '{}',
  });

  const body = await parseResponse<IdentityResponse>(response);
  if (!response.ok) {
    throw new Error(`[${response.status}] ${body.error ?? response.statusText}`);
  }
  return body;
}

/**
 * DELETE /t/events/d/{externalTenantId}/{visitorId}
 * Detach all known identities from a visitor ID.
 */
export async function detachIdentity(
  config: SseConfig,
  visitorId: string
): Promise<IdentityResponse> {
  const { gatewayHost, externalTenantId, bearerToken } = config;
  const url = `${gatewayHost.replace(/\/$/, '')}/t/events/d/${encodeURIComponent(externalTenantId)}/${encodeURIComponent(visitorId)}`;

  const response = await fetch(url, {
    method: 'DELETE',
    headers: {
      Accept: 'application/json',
      ...authHeader(bearerToken),
    },
  });

  const body = await parseResponse<IdentityResponse>(response);
  if (!response.ok) {
    throw new Error(`[${response.status}] ${body.error ?? response.statusText}`);
  }
  return body;
}

/**
 * GET /t/content/{externalTenantId}/id_type={idType}/id_value={idValue}/spotId={spotId}
 * Fetch spot content payload (HTML or JSON envelope) for rendering on the client.
 */
export async function fetchSpotContent(
  config: SseConfig,
  idType: string,
  idValue: string,
  spotId: string
): Promise<SpotContentResponse> {
  const { gatewayHost, externalTenantId, bearerToken } = config;
  const url = `${gatewayHost.replace(/\/$/, '')}/t/content/${encodeURIComponent(externalTenantId)}/id_type=${encodeURIComponent(idType)}/id_value=/spotkey=${encodeURIComponent(spotId)}`;
  console.log("Req response", url, authHeader(bearerToken))
  const response = await fetch(url, {
    method: 'GET',
    headers: {
      Accept: 'application/json, text/html, */*',
      ...authHeader(bearerToken),
    },
  });

  const body = await response.text();
  console.log("Req response", body)
  if (!response.ok) {
    throw new Error(`[${response.status}] ${body || response.statusText}`);
  }

  return {
    status: response.status,
    contentType: response.headers.get('content-type') ?? '',
    body,
  };
}
