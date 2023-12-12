import * as React from 'react';
import type { NativeStackScreenProps } from '@react-navigation/native-stack';
import type { RootTabParameterList } from '../RootNavigation';
type Props = NativeStackScreenProps<RootTabParameterList, 'Details'>;
export default function DetailsScreen({ navigation, route }: Props): React.JSX.Element;
export {};
