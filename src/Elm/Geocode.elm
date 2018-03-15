module Geocode exposing (..)

import Json.Decode as Decode
import Json.Decode.Pipeline exposing (..)


type alias Coord =
    { lon : Float
    , lat : Float
    }


type alias Geocode =
    { cityName : String
    , coord : Coord
    }


coord : Decode.Decoder Coord
coord =
    decode Coord
        |> requiredAt [ "geometry", "location", "lng" ] Decode.float
        |> requiredAt [ "geometry", "location", "lat" ] Decode.float


geocode : Decode.Decoder Geocode
geocode =
    let
        decoder =
            Decode.list (Decode.field "long_name" Decode.string)
                |> Decode.field "address_components"
                >> Decode.list
                |> Decode.map (List.head >> Maybe.andThen List.head >> Maybe.withDefault "")
    in
        decode Geocode
            |> required "results" decoder
            |> required "results" (Decode.list coord |> Decode.map (List.head >> Maybe.withDefault (Coord 0 0)))
