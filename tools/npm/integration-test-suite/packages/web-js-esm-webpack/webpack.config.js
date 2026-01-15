const path = require('path');
const CopyPlugin = require('copy-webpack-plugin');

module.exports = {
  entry: './src/bootstrap.js',
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: 'bootstrap.js',
  },
  mode: 'production',
  resolve: {
    fallback: {
      "crypto": require.resolve("crypto-browserify"),
      "stream": require.resolve("stream-browserify"),
      "vm": require.resolve("vm-browserify"),
      "fs": false
    }
  },
  performance: {
    maxAssetSize: 4 * 1024 * 1024, // 4MB to avoid warning
  },
  plugins: [
    new CopyPlugin({ patterns: ['./public/index.html'] }),
  ],
};
