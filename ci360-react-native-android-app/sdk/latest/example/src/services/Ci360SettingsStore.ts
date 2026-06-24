export interface Ci360RuntimeSettings {
  gatewayHost: string;
  externalTenantId: string;
  appId: string;
}

export const DEFAULT_CI360_SETTINGS: Ci360RuntimeSettings = {
  gatewayHost: '',
  externalTenantId: '',
  appId: '',
};

let currentSettings: Ci360RuntimeSettings = { ...DEFAULT_CI360_SETTINGS };
const listeners = new Set<(settings: Ci360RuntimeSettings) => void>();

const sanitizeSettings = (
  next: Partial<Ci360RuntimeSettings>
): Ci360RuntimeSettings => {
  const gatewayHost =
    (next.gatewayHost ?? currentSettings.gatewayHost).trim();
  const externalTenantId =
    (next.externalTenantId ?? currentSettings.externalTenantId).trim();
  const appId =
    (next.appId ?? currentSettings.appId).trim();

  return {
    gatewayHost,
    externalTenantId,
    appId,
  };
};

export const getCi360Settings = (): Ci360RuntimeSettings => ({
  ...currentSettings,
});

export const updateCi360Settings = (
  next: Partial<Ci360RuntimeSettings>
): Ci360RuntimeSettings => {
  currentSettings = sanitizeSettings(next);
  listeners.forEach((listener) => listener({ ...currentSettings }));
  return { ...currentSettings };
};

export const subscribeCi360Settings = (
  listener: (settings: Ci360RuntimeSettings) => void
): (() => void) => {
  listeners.add(listener);
  listener({ ...currentSettings });
  return () => {
    listeners.delete(listener);
  };
};
