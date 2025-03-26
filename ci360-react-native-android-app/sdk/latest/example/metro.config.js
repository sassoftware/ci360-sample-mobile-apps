const path = require('path');
const { getDefaultConfig } = require('@react-native/metro-config');
const { getConfig } = require('react-native-builder-bob/metro-config');
const pkg = require('../package.json');

const root = path.resolve(__dirname, '..');

/**
 * Metro configuration
 * https://facebook.github.io/metro/docs/configuration
 *
 * @type {import('metro-config').MetroConfig}
 */
module.exports = getConfig(getDefaultConfig(__dirname), {
  root,
  pkg,
  project: __dirname,
});

// const path = require('path');
// const { getDefaultConfig } = require('@react-native/metro-config');
// const { getConfig } = require('react-native-builder-bob/metro-config');
// // const escape = require('escape-string-regexp');
// const exclusionList = require('metro-config/src/defaults/exclusionList');
// const pkg = require('../package.json');

// const root = path.resolve(__dirname, '..');
// const parent = path.resolve(__dirname, '../src');
// const appProj = path.resolve(__dirname, './src');
// const config = getConfig(getDefaultConfig(__dirname), {
//   root,
//   pkg,
//   project: __dirname,
// });
// config.watchFolders = [parent, appProj];
// config.resolver = {
//   blacklistRE: exclusionList([/node_modules\/.*/, /build\/.*/]),
//   useWatchman: true,
// };
// module.exports = config;

// module.exports = getConfig(getDefaultConfig(__dirname), {
//   root,
//   pkg,
//   project: __dirname,
// });

// const modules = Object.keys({
//   ...pkg.peerDependencies,
// });

// module.exports = {
//   projectRoot: __dirname,
//   watchFolders: [parent, appProj],

//   // We need to make sure that only one version is loaded for peerDependencies
//   // So we block them at the root, and alias them to the versions in example's node_modules
// resolver: {
//   blacklistRE: exclusionList(
//     modules.map(
//       (m) =>
//         new RegExp(`^${escape(path.join(root, 'node_modules', m))}\\/.*$`)
//     )
//   ),

//   extraNodeModules: modules.reduce((acc, name) => {
//     acc[name] = path.join(__dirname, 'node_modules', name);
//     return acc;
//   }, {}),
// },

//   transformer: {
//     getTransformOptions: async () => ({
//       transform: {
//         experimentalImportSupport: false,
//         inlineRequires: true,
//       },
//     }),
//   },
// };
