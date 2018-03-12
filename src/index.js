'use struct'

require('./index.html');

const Elm = require('./Elm/Main.elm');
const main = document.getElementById('main');

const app = Elm.Main.embed(main);

// localStorage.clear();

app.ports.getCityList_.subscribe(_ => {
    const cityList = JSON.parse(localStorage.getItem('cities'));
    if (cityList != null) {
        console.log(cityList);
        app.ports.returnCityList.send(cityList);
    }
});

app.ports.updateCityList.subscribe(cities => {
    localStorage.setItem('cities', JSON.stringify(cities));
});
