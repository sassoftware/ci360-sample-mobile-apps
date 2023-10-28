import * as React from 'react';
import type { NativeStackScreenProps } from '@react-navigation/native-stack';
import type { RootTabParameterList } from '../RootNavigation';
type Props = NativeStackScreenProps<RootTabParameterList, 'Login'>;
export default function LoginScreen({ navigation }: Props): React.JSX.Element;
export {};
