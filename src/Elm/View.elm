module View exposing (..)

import Html exposing (..)
import Model exposing (..)

view : Model -> Html Msg
view model =
    text <| toString model.city