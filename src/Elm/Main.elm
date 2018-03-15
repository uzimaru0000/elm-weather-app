module Main exposing (..)

import Html exposing (Html, program, text)
import Update exposing (..)
import Model exposing (..)
import View exposing (..)
import Ports exposing (getGeocodeList, returnGeocodeList)


main : Program Never Model Msg
main =
    program
        { init = init ! [ getGeocodeList ]
        , update = update
        , view = view
        , subscriptions = always (returnGeocodeList ReturnGeocodeList)
        }
