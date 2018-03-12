module Update exposing (..)

import Model exposing (..)
import Weather exposing (..)
import Http exposing (..)
import Ports exposing (..)
import Material


apiKey : String
apiKey =
    "94d26b113fb10bb70a9dfbeecc28dfbe"


baseUrl : String
baseUrl =
    "https://api.openweathermap.org/data/2.5/"


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReturnCityList list ->
            ( model
            , list
                |> List.filterMap .id
                |> List.map getForecastFromId
                |> Cmd.batch
            )

        GetForecast (Ok forecast) ->
            let
                forecasts =
                    model.forecasts
                        ++ (if model.forecasts |> List.map .city |> List.member forecast.city |> not then
                                [ forecast ]
                            else
                                []
                           )
            in
                { model | forecasts = forecasts } ! [ forecasts |> List.map .city |> updateCityList ]

        GetForecast (Err message) ->
            (model |> Debug.log "") ! []

        InputQuery query ->
            ( { model | query = query }, Cmd.none )

        AddCity ->
            { model | query = "" } ! [ getForecastFromCity model.query ]

        RemoveCity index ->
            let
                forecasts =
                    model.forecasts
                        |> List.indexedMap (,)
                        |> List.filter (Tuple.first >> (/=) index)
                        |> List.map Tuple.second
            in
                ( { model | forecasts = forecasts }
                , forecasts |> List.map .city |> updateCityList
                )

        Mdl msg_ ->
            Material.update Mdl msg_ model

        _ ->
            model ! []


getForecast : String -> Cmd Msg
getForecast query =
    send GetForecast <|
        get (String.join "" [ baseUrl, "forecast/daily?", query, "&appid=", apiKey ]) forecast


getForecastFromCity : String -> Cmd Msg
getForecastFromCity city =
    getForecast (String.join "" [ "q=", city, ",jp" ])


getForecastFromId : Int -> Cmd Msg
getForecastFromId id =
    getForecast (String.join "" [ "id=", toString id ])
