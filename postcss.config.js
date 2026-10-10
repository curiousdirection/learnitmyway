module.exports = ctx => {
  return {
    map: ctx.env === 'production' ? false : ctx.options.map, // source maps
    plugins: {
      "postcss-import": { path: ["assets/css"] },
      "postcss-preset-env": {
        stage: 0
      },
    }
  }
};
