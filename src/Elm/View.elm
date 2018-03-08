module View exposing (..)

import Date exposing (fromTime)
import Date.Format exposing (format)
import Html exposing (..)
import Html.Attributes exposing (type_)
import Html.Events exposing (onClick, onInput)
import Model exposing (..)
import Weather exposing (..)

-- MaterialModule
import Material.Layout as Layout
import Material.Scheme as Scheme
import Material.Options as Options
import Material.Grid as Grid


view : Model -> Html Msg
view model =
    Layout.render Mdl model.mdl
    [ Layout.fixedHeader
    ]
    { header = [ text "" ]
    , drawer = []
    , tabs = ([], [])
    , main = [
        Options.div [ Options.css "margin" "8px" ]
            [ input [ type_ "text", onInput InputQuery ] []
            , button [ onClick Search ] [ text "Go" ]
            , result model.forecast
            ]
        ]
    }
    |> Scheme.top


result : Maybe Forecast -> Html Msg
result forecast =
    case forecast of
        Just x ->
            Grid.grid
                []
                [ Grid.cell
                    []
                    [ div []
                        [ forecastView x
                        , text <| toString x
                        ]
                    ]
                ]

        Nothing ->
            text ""


forecastView : Forecast -> Html Msg
forecastView forecast =
    div []
        [ cityView forecast.city
        , div []
            (forecast.list
                |> List.map dataView
            )
        ]


cityView : City -> Html Msg
cityView city =
    div [] [ h1 [] [ text city.name ] ]


dataView : Data -> Html Msg
dataView data =
    ul []
        [ li [] [ text <| format "%Y-%m-%d %H:%M" <| fromTime data.time ]
        , li [] [ text <| "temp : " ++ (tempFormat data.temp.temp) ++ "℃" ]
        , li [] [ data.weather |> Maybe.andThen weatherView |> Maybe.withDefault (text "") ]
        ]

weatherView : Weather -> Maybe (Html Msg)
weatherView weather =
    weather.name
    |> text
    |> Just


tempFormat : Float -> String
tempFormat temp =
    let
        frac =
            temp - (floor temp |> toFloat)
        fracString =
            toString frac
            |> String.slice 1 3

        intString =
            floor temp
            |> toString
    in
        intString ++ fracString