module Main exposing (..)

import Html exposing (Html, program, text)
import Update exposing (..)
import Model exposing (..)
import View exposing (..)
import Material


main : Program Never Model Msg
main =
    program
        { init = { forecast = Nothing, query = "", mdl = Material.model } ! []
        , update = update
        , view = view
        , subscriptions = always Sub.none
        }
