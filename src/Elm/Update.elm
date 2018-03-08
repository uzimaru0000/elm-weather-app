module Update exposing (..)

import Model exposing (..)
import Weather exposing (..)
import Http exposing (..)
import Material


apiKey : String
apiKey =
    "94d26b113fb10bb70a9dfbeecc28dfbe"


baseUrl : String
baseUrl =
    "http://api.openweathermap.org/data/2.5/forecast"


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Search ->
            model ! [ getWeather model.query ]

        InputQuery query ->
            { model | query = query } ! []

        GetWeather (Ok weather) ->
            { model | forecast = Just weather } ! []

        GetWeather (Err _) ->
            { model | forecast = Nothing } ! []

        Mdl msg_ ->
            Material.update Mdl msg_ model


getWeather : String -> Cmd Msg
getWeather query =
    send GetWeather <|
        get (String.join "" [ baseUrl, "?q=", query, ",jp", "&appid=", apiKey ]) forecast
