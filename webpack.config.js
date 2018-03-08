'use strict'

module.exports = {
    entry: {
        app: './src/index.js'
    },
    output: {
        path: `${__dirname}/docs`,
        filename: '[name].js'
    },
    module: {
        rules: [
            {
                test: /\.html$/,
                exclude: /node_modules/,
                use: 'file-loader?name=[name].[ext]'
            },
            {
                test: /\.css$/,
                use: [ 'style-loader', 'css-loader' ]
            },
            {
                test: /\.elm$/,
                exclude: [ /node_modules/, /elm-stuff/ ],
                use: 'elm-webpack-loader'
            }
        ]
    },
    devServer: {
        inline: true,
        stats: 'errors-only'
    }
};