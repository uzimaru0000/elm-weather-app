'use struct'

require('./index.html');

const Elm = require('./Elm/Main.elm');
const app = Elm.Main.fullscreen();

app.ports.getGeocodeList_.subscribe(_ => {
    const cityList = JSON.parse(localStorage.getItem('cities'));
    if (cityList != null) {
        app.ports.returnGeocodeList.send(cityList);
    }
});

app.ports.updateGeocodeList.subscribe(cities => {
    localStorage.setItem('cities', JSON.stringify(cities));
});
