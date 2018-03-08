module Model exposing (..)

import Http exposing (..)
import Weather exposing (..)
import Material

type alias Model =
    { forecast : Maybe Forecast
    , query : String
    , mdl : Material.Model
    }

type Msg
    = GetWeather (Result Http.Error Forecast)
    | Search
    | InputQuery String
    | Mdl (Material.Msg Msg)