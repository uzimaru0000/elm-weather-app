'use struct'

require('./index.html');

const Elm = require('./Elm/Main.elm');
const main = document.getElementById('main');

const app = Elm.Main.embed(main);