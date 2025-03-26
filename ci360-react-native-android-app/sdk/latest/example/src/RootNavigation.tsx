import { createNavigationContainerRef } from "@react-navigation/native";

export type RootTabParameterList = {
  Home: {
    screen?: 'HomeStack' | 'ProfileStack' | 'Notifications' | 'Content' | 'Search';
    params?: any;
  };
  Profile: undefined;
  Settings: undefined;
  Config: undefined;
  Diagnostics?: { diagnosticLink: string };
};

export const navigationRef = createNavigationContainerRef<RootTabParameterList>();

export function navigate(name: keyof RootTabParameterList, params: any) {
  if (navigationRef.isReady()) {
    console.log(name, params);
    navigationRef.navigate(name, params);
  }
}