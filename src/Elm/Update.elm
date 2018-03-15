module Update exposing (..)

import Model exposing (..)
import Weather exposing (..)
import Geocode exposing (..)
import Http exposing (..)
import Ports exposing (..)
import Json.Decode as Decode
import Material


weatherMapApiKey : String
weatherMapApiKey =
    ""


weatherMapBaseUrl : String
weatherMapBaseUrl =
    "https://api.openweathermap.org/data/2.5/"


geocodingApiKey : String
geocodingApiKey =
    ""

geocodingBaseUrl : String
geocodingBaseUrl =
    "https://maps.googleapis.com/maps/api/geocode/"


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReturnGeocodeList list ->
            ( model
            , list
                |> List.map getForecastFromCoord
                |> Cmd.batch
            )

        GetForecast code (Ok list) ->
            let
                forecasts =
                    model.forecasts
                        ++ (if model.forecasts |> List.map .geocode |> List.member code |> not then
                                [ Forecast code list ]
                            else
                                []
                           )
            in
                { model | forecasts = forecasts, query = "", isError = False } ! [ forecasts |> List.map .geocode |> updateGeocodeList ]

        GetForecast _ (Err message) ->
            { model | isError = True } ! []
        
        GetGeocode (Ok geocode) ->
            (model, getForecastFromCoord geocode)

        GetGeocode (Err message) ->
            { model | isError = True } ! []

        InputQuery query ->
            ( { model | query = query, isError = False }, Cmd.none )

        AddCity ->
            (model, if String.isEmpty model.query |> not then getGeocode model.query else Cmd.none)

        RemoveCity index ->
            let
                forecasts =
                    model.forecasts
                        |> List.indexedMap (,)
                        |> List.filter (Tuple.first >> (/=) index)
                        |> List.map Tuple.second
            in
                ( { model | forecasts = forecasts }
                , forecasts |> List.map .geocode |> updateGeocodeList
                )

        Mdl msg_ ->
            Material.update Mdl msg_ model

        _ ->
            model ! []


getForecast : Geocode -> String -> Cmd Msg
getForecast code query =
    send (GetForecast code) <|
        get (String.join "" [ weatherMapBaseUrl, "forecast/daily?", query, "&units=metric", "&appid=", weatherMapApiKey ]) (Decode.field "list" <| Decode.list data)


getForecastFromCoord : Geocode -> Cmd Msg
getForecastFromCoord code =
    getForecast code (String.join "" [ "lat=", toString code.coord.lat, "&lon=", toString code.coord.lon ])


getGeocode : String -> Cmd Msg
getGeocode query =
    send GetGeocode <|
        get (String.join "" [ geocodingBaseUrl, "json?address=", encodeUri query, "&key=", geocodingApiKey ] |> Debug.log "") geocode
