module Weather exposing (..)

import Date exposing (..)
import Geocode exposing (Coord)
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (..)


type alias City =
    { id : Maybe Int
    , name : String
    , coord : Coord
    }


type alias Temp =
    { day : Float
    , min : Float
    , max : Float
    , night : Float
    , eve : Float
    , morn : Float
    }


type alias Weather =
    { id : Int
    , name : String
    , description : String
    }


type alias Data =
    { time : Date
    , temp : Temp
    , weather : Maybe Weather
    }


temp : Decode.Decoder Temp
temp =
    decode Temp
        |> required "day" Decode.float
        |> required "min" Decode.float
        |> required "max" Decode.float
        |> required "night" Decode.float
        |> required "eve" Decode.float
        |> required "morn" Decode.float


weather : Decode.Decoder Weather
weather =
    decode Weather
        |> required "id" Decode.int
        |> required "main" Decode.string
        |> required "description" Decode.string


data : Decode.Decoder Data
data =
    decode Data
        |> custom (Decode.field "dt" Decode.float |> Decode.map ((*) 1000 >> Date.fromTime))
        |> required "temp" temp
        |> custom (Decode.field "weather" (Decode.list weather) |> Decode.map List.head)

