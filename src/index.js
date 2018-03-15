'use struct'

require('./index.html');

const Elm = require('./Elm/Main.elm');
const app = Elm.Main.fullscreen();

app.ports.getGeocodeList_.subscribe(_ => {
    const codeList = JSON.parse(localStorage.getItem('geocode'));
    if (codeList != null) {
        app.ports.returnGeocodeList.send(codeList);
    }
});

app.ports.updateGeocodeList.subscribe(cities => {
    localStorage.setItem('geocode', JSON.stringify(cities));
});
