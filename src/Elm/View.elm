module View exposing (..)

import Date.Format as Format exposing (format)
import Html exposing (..)
import Html.Attributes exposing (href, target)
import Model exposing (..)
import Weather exposing (..)
import FormatNumber as NFormat exposing (format)
import FormatNumber.Locales exposing (Locale)


-- MaterialModule

import Material
import Material.Layout as Layout
import Material.Scheme as Scheme
import Material.Options as Options
import Material.Grid as Grid exposing (Device(..))
import Material.Typography as Typo
import Material.Textfield as Textfield
import Material.Button as Button
import Material.Card as Card
import Material.Elevation as Elevation
import Material.Color as Color
import Material.Icon as Icon


view : Model -> Html Msg
view model =
    Layout.render Mdl
        model.mdl
        [ Layout.fixedHeader
        ]
        { header =
            [ Layout.row []
                [ Layout.title []
                    [ Options.styled a
                        [ Color.text Color.white
                        , Options.attribute <| href "https://github.com/uzimaru0000/elm-weather-app"
                        , Options.attribute <| target "_blank"
                        , Options.css "text-decoration" "none"
                        ]
                        [ text "WeatherApp" ]
                    ]
                ]
            ]
        , drawer = []
        , tabs = ( [], [] )
        , main =
            [ Grid.grid
                [ Options.css "padding" "4% 8%"
                , Options.css "margin" "auto"
                ]
              <|
                List.concat
                    [ inputForm model
                    , model.forecasts
                        |> List.indexedMap (,)
                        |> List.map (card model.mdl >> flip (::) [] >> Grid.cell [ Grid.size All 4 ])
                    ]
            ]
        }
        |> Scheme.topWithScheme Color.Cyan Color.Orange


inputForm : Model -> List (Grid.Cell Msg)
inputForm model =
    [ Grid.cell [ Grid.size Desktop 11, Grid.size Tablet 7, Grid.size Phone 3 ]
        [ Textfield.render Mdl
            [ 0 ]
            model.mdl
            [ Textfield.label "Input PlaceName"
            , Textfield.floatingLabel
            , Textfield.value model.query
            , Textfield.error (model.query ++ " is not found.") |> Options.when model.isError
            , Options.onInput InputQuery
            , Options.css "width" "100%"
            ]
            []
        ]
    , Grid.cell [ Grid.size All 1 ]
        [ Button.render Mdl
            [ 1 ]
            model.mdl
            [ Button.raised
            , Button.colored
            , Button.ripple
            , Options.onClick AddCity
            , Options.css "width" "100%"
            , Color.text Color.white
            ]
            [ text "Add" ]
        ]
    ]


card : Material.Model -> ( Int, Forecast ) -> Html Msg
card mdl ( index, data ) =
    Card.view
        [ Elevation.e4
        , Options.css "width" "100%"
        ]
        [ cardHeader data
        , cardText data
        , cardAction mdl ( index, data )
        ]


cardHeader : Forecast -> Card.Block Msg
cardHeader { geocode, list } =
    let
        today =
            List.head list

        date =
            today
                |> Maybe.map (.time >> Format.format "%Y-%m-%d (%a)")
                |> Maybe.withDefault ""

        weather =
            today
                |> Maybe.andThen .weather
                |> Maybe.map (.id >> weatherIcon Icon.size48)
                |> Maybe.withDefault (text "")

        temp =
            today
                |> Maybe.map (.temp >> .day >> NFormat.format tempLocale)
                |> Maybe.withDefault ""
    in
        Card.title
            []
            [ Card.head [] [ text geocode.cityName ]
            , Card.subhead
                [ Options.css "display" "flex"
                , Options.css "align-items" "center"
                , Options.css "width" "80%"
                ]
                [ Options.span [] [ text date ]
                , Options.span [ Options.css "margin-left" "auto" ] [ weather ]
                ]
            , Options.div
                [ Typo.display4
                , Color.text Color.primary
                , Options.css "padding" "2rem 2rem 0"
                ]
                [ text <| temp ++ "°" ]
            ]


cardText : Forecast -> Card.Block Msg
cardText data =
    let
        items =
            List.tail data.list
                |> Maybe.map (List.map weatherRow)
                |> Maybe.withDefault []
    in
        Card.text
            []
            items


cardAction : Material.Model -> ( Int, Forecast ) -> Card.Block Msg
cardAction mdl ( index, data ) =
    Card.actions
        [ Card.border
        , Options.css "display" "flex"
        , Options.css "justify-content" "flex-end"
        ]
        [ Button.render Mdl
            [ index, 0 ]
            mdl
            [ Button.ripple
            , Options.onClick <| RemoveCity index
            , Color.text <| Color.color Color.Red Color.S500
            ]
            [ text "Delete" ]
        ]


tempLocale : Locale
tempLocale =
    Locale 1 "," "." "-" ""


weatherRow : Data -> Html Msg
weatherRow data =
    let
        day =
            data.time |> Format.format "%m / %d"

        high =
            NFormat.format tempLocale data.temp.max ++ "°"

        low =
            NFormat.format tempLocale data.temp.min ++ "°"

        icon =
            data.weather |> Maybe.map (.id >> weatherIcon Icon.size18) |> Maybe.withDefault (text "")
    in
        Grid.grid []
            [ Grid.cell
                [ Grid.size Desktop 4
                , Grid.size Tablet 2
                , Grid.size Phone 1
                , Typo.center
                ]
                [ text day ]
            , Grid.cell
                [ Grid.size Desktop 4
                , Grid.size Tablet 3
                , Grid.size Phone 1
                , Typo.center
                ]
                [ icon ]
            , Grid.cell
                [ Grid.size Desktop 4
                , Grid.size Tablet 3
                , Grid.size Phone 2
                , Typo.center
                ]
                [ text <| high ++ " / " ++ low ]
            ]


weatherIcon : Icon.Property Msg -> Int -> Html Msg
weatherIcon size id =
    case ( id // 100 % 10, id // 10 % 10, id % 10 ) of
        ( 2, _, _ ) ->
            Icon.view "flash_on" [ Color.text <| Color.color Color.Yellow Color.S500, size ]

        ( 3, _, _ ) ->
            Icon.view "blur_on" [ Color.text <| Color.color Color.Grey Color.S300, size ]

        ( 5, _, _ ) ->
            Icon.view "grain" [ Color.text <| Color.color Color.LightBlue Color.S500, size ]

        ( 6, _, _ ) ->
            Icon.view "ac_unit" [ Color.text <| Color.color Color.Cyan Color.S500, size ]

        ( 8, 0, 0 ) ->
            Icon.view "wb_sunny" [ Color.text <| Color.color Color.Amber Color.S500, size ]

        ( 8, 0, _ ) ->
            Icon.view "cloud" [ Color.text <| Color.color Color.Grey Color.S500, size ]

        ( _, _, _ ) ->
            Icon.view "error" [ Color.text <| Color.color Color.Grey Color.S500, size ]
