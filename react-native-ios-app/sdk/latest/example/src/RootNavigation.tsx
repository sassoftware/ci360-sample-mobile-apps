import { createNavigationContainerRef } from "@react-navigation/native";

export type RootTabParameterList = {
  Login: {diagnosticLink: string},
  Details: {userId: string},
  Home: {},
  Views: {},
  Messages: {},
  Diagnostics: {}
}

export const navigationRef = createNavigationContainerRef();

export function navigate(name: string, params: any) {
  if (navigationRef.isReady()) {
    navigationRef.navigate(name, params);
  }
}
