module Main exposing (..)

import Html exposing (Html, program, text)
import Weather exposing (..)
import Update exposing (..)
import Model exposing (..)
import View exposing (..)
import Http exposing (..)


apiKey : String
apiKey =
    "94d26b113fb10bb70a9dfbeecc28dfbe"

baseUrl : String
baseUrl =
    "http://api.openweathermap.org/data/2.5/forecast"


getWeather : String -> Cmd Msg
getWeather query =
    send GetWeather <|
    get (String.join "" [baseUrl, "?", query, "&appid=", apiKey]) forecast


main : Program Never Model Msg
main =
    program
        { init = { city = Nothing } ! [ getWeather "q=Japan,jp" ]
        , update = update
        , view = view
        , subscriptions = always Sub.none
        }
