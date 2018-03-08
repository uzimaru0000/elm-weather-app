module Model exposing (..)

import Http exposing (..)
import Weather exposing (..)

type alias Model =
    { city : Maybe Forecast
    }

type Msg
    = GetWeather (Result Http.Error Forecast)