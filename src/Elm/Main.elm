module Main exposing (..)

import Html exposing (Html, program, text)
import Update exposing (..)
import Model exposing (..)
import View exposing (..)
import Ports exposing (getCityList, returnCityList)


main : Program Never Model Msg
main =
    program
        { init = init ! [ getCityList ]
        , update = update
        , view = view
        , subscriptions = always (returnCityList ReturnCityList)
        }
