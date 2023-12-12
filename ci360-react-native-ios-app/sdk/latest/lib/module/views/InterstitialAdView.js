import { requireNativeComponent, UIManager } from "react-native";
const ComponentName = 'InterstitialAdView';
const LINKING_ERROR = `The ${ComponentName} doesn't seem to be linked`;
const InterstitialAdView = UIManager.getViewManagerConfig(ComponentName) != null ? requireNativeComponent(ComponentName) : () => {
  throw new Error(LINKING_ERROR);
};
export default InterstitialAdView;
//# sourceMappingURL=InterstitialAdView.js.map