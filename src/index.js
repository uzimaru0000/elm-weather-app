'use struct'

require('./index.html');

const Elm = require('./Elm/Main.elm');
const app = Elm.Main.fullscreen();

app.ports.getCityList_.subscribe(_ => {
    const cityList = JSON.parse(localStorage.getItem('cities'));
    if (cityList != null) {
        app.ports.returnCityList.send(cityList);
    }
});

app.ports.updateCityList.subscribe(cities => {
    localStorage.setItem('cities', JSON.stringify(cities));
});
