const TerserPlugin = require('terser-webpack-plugin');
const MiniCSSExtractPlugin = require('mini-css-extract-plugin')
const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin')
const { CleanWebpackPlugin } = require('clean-webpack-plugin')
const { resolve } = require('path')
const CopyPlugin = require('copy-webpack-plugin')

const pathsToClean = [
  './assets/dist/',
]

const cleanOptions = {
  root: resolve(__dirname, '..')
}

const buildFilename = function(name, extension) {
  let folder = extension.substring(1);
  let path   = folder + '/' + name + '-[contenthash]' + extension;
  return path
}

module.exports = {
  mode: 'production',
  entry: {
    "app": ['./assets/src/js/html.js', './assets/src/less/entry/html-ruby.less'],
  },
  output: {
    path: resolve(__dirname, '../dist'),
    filename: (chunkData) => buildFilename(chunkData.chunk.name, '.js')
  },
  resolve: {
    extensions: ['.js', '.less']
  },
  optimization: {
    minimizer: [
      new TerserPlugin({
        extractComments: false,
      }),
      new OptimizeCSSAssetsPlugin({})
    ]
  },
  module: {
    rules: [
      {
        test: /\.handlebars$/,
        loader: 'handlebars-loader',
        query: {
          helperDirs: [
            resolve(__dirname, 'js', 'template-helpers')
          ]
        }
      },
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader',
          options: {
            presets: ['@babel/preset-env'],
            cacheDirectory: true
          }
        }
      },
      {
        test: /\.less$/,
        use: [
          {
            loader: MiniCSSExtractPlugin.loader,
          },
          {
            loader: 'css-loader',
            options: {
              url: false,
            },
          },
          {
            loader: 'postcss-loader',
          },
          {
            loader: 'less-loader',
            options: {
              relativeUrls: false,
            }
          },
        ],
      },
      {
        test: /\.(eot|svg|ttf|woff)$/,
        use: [
          {
            loader: 'file-loader',
            options: {
              name: '[name].[ext]',
              outputPath: 'fonts/'
            }
          }
        ]
      }
    ]
  },
  plugins: [
    new MiniCSSExtractPlugin({moduleFilename: ({name}) => buildFilename(name, '.css')}),
    new CleanWebpackPlugin({
      cleanOnceBeforeBuildPatterns: [
        './**/*',
      ],
    }),
    new CopyPlugin([
      { from: './assets/src/fonts', to: './fonts' },
    ]),
  ],
}
