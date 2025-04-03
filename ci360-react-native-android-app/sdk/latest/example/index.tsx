console.log('index.js is loaded');
import { AppRegistry } from 'react-native';
import App from './src/App';
import { name as appName } from './app.json';

console.log('name is ', appName);
AppRegistry.registerComponent(appName, () => App); //'main'
