var path = require('path');
var HtmlWebpackPlugin = require('html-webpack-plugin');
var ExtractTextPlugin = require('extract-text-webpack-plugin');
var CopyWebpackPlugin = require('copy-webpack-plugin');

module.exports = {
    devtool: 'sourcemap',
    entry: {
        app: ['./src/index.js']
    },
    output: {
        path: path.resolve(__dirname, 'build'),
        publicPath: './',
        filename: 'instead.[hash].js'
    },
    module: {
        loaders: [
            {
                test: /\.css/,
                loader: ExtractTextPlugin.extract({fallback: 'style-loader', use: 'css-loader'})
            },
            {
                test: /\.(png|jpg|jpeg|gif|svg|woff|woff2|ttf|eot|ico)$/,
                loader: 'file-loader'
            },
            {
                test: /\.html$/,
                loader: 'raw-loader'
            }
        ]
    },
    plugins: [
        new CopyWebpackPlugin([
            {from: 'instead/themes', to: 'themes'},
            {from: 'instead/git/instead/icon/sdl_instead_1x32.png', to: 'instead.png'},
            {from: 'scripts/list_games.js'},
            {from: 'instead/stead2.json'},
            {from: 'instead/stead3.json'},
            {from: 'node_modules/text-encoding/lib/encoding.js'},
            {from: 'node_modules/text-encoding/lib/encoding-indexes.js'}
        ], {
            ignore: [
                'Makefile',
                'CMakeLists.txt',
                'Makefile.windows'
            ]
        }),
        new HtmlWebpackPlugin({
            template: './src/index.html',
            inject: 'body'
        }),
        new ExtractTextPlugin('style.[hash].css')
    ],
    devServer: {
        contentBase: './build',
        stats: 'minimal'
    },
    resolve: {
        alias: {
            fs: path.join(__dirname, 'src', 'lua', 'stubs', 'fs.js'), // filesystem
            ws: path.join(__dirname, 'src', 'lua', 'stubs', 'ws.js')  // websockets
        }
    }
};
