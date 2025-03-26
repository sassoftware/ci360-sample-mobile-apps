import { requireNativeComponent, UIManager, ViewStyle } from 'react-native';

type Props = {
  spotId: string;
  useLocResources: boolean;
  resourcePath: string;
  viewId: string;
  notVisible: boolean;
  style: ViewStyle;
};

const ComponentName = 'InlineAdViewWithLocalResources';

const LINKING_ERROR = `The ${ComponentName} does not seem to be linked`;

const InlineAdViewWithLocalResources =
UIManager.getViewManagerConfig(ComponentName) != null
? requireNativeComponent<Props>(ComponentName)
: () => {
  throw new Error(LINKING_ERROR);
};

export default InlineAdViewWithLocalResources;
