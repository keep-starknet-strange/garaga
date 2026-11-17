module.exports = {
  output: {
    filename: 'bundle.js',
    clean: true,
  },
  mode: 'production',
  resolve: {
    fallback: {
      "fs": false
    }
  },
  performance: {
    maxAssetSize: 4 * 1024 * 1024,
    maxEntrypointSize: 4 * 1024 * 1024,
  },
};
