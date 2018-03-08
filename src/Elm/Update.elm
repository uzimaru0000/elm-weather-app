module Update exposing (..)

import Model exposing (..)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        GetWeather (Ok weather) ->
            { model | city = Just weather } ! []
        GetWeather (Err message) ->
            Debug.crash <| toString message