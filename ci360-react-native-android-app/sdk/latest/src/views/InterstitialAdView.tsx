import { requireNativeComponent, UIManager } from "react-native";

type Props = {
  spotId: string;
}
const ComponentName = 'InterstitialAdView';
const LINKING_ERROR = `The ${ComponentName} doesn't seem to be linked`;

const InterstitialAdView =
  UIManager.getViewManagerConfig(ComponentName) != null
    ? requireNativeComponent<Props>(ComponentName)
    : () => {
      throw new Error(LINKING_ERROR);
    }

export default InterstitialAdView;
