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
        publicPath: '/',
        filename: 'app.js'
    },
    module: {
        loaders: [
            {
                test: /\.css/,
                loader: ExtractTextPlugin.extract('style', 'css')
            },
            {
                test: /\.(png|jpg|jpeg|gif|svg|woff|woff2|ttf|eot|ico)$/,
                loader: 'file'
            },
            {
                test: /\.html$/,
                loader: 'raw'
            }
        ]
    },
    plugins: [
        new CopyWebpackPlugin([
            {from: 'instead/git/instead/themes', to: 'themes'}
        ]),
        new HtmlWebpackPlugin({
            template: './src/index.html',
            inject: 'body'
        }),
        new ExtractTextPlugin('styles.css')
    ],
    devServer: {
        contentBase: './src/assets',
        stats: 'minimal'
    },
    resolve: {
        alias: {
            fs: path.join(__dirname, 'src', 'lua', 'stubs', 'fs.js'), // filesystem
            ws: path.join(__dirname, 'src', 'lua', 'stubs', 'ws.js')  // websockets
        }
    }
};
