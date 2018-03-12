module Weather exposing (..)

import Date exposing (..)
import Json.Decode as Decode exposing (..)
import Json.Decode.Pipeline exposing (..)


type alias Coord =
    { lon : Float
    , lat : Float
    }


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

type alias Forecast =
    { city : City
    , list : List Data
    }


temp : Decoder Temp
temp =
    decode Temp
        |> custom (field "day" float |> Decode.map ((+) -273.15))
        |> custom (field "min" float |> Decode.map ((+) -273.15))
        |> custom (field "max" float |> Decode.map ((+) -273.15))
        |> custom (field "night" float |> Decode.map ((+) -273.15))
        |> custom (field "eve" float |> Decode.map ((+) -273.15))
        |> custom (field "morn" float |> Decode.map ((+) -273.15))


weather : Decoder Weather
weather =
    decode Weather
        |> required "id" int
        |> required "main" string
        |> required "description" string


data : Decoder Data
data =
    decode Data
        |> custom (field "dt" float |> Decode.map ((*) 1000 >> Date.fromTime))
        |> required "temp" temp
        |> custom (field "weather" (list weather) |> Decode.map List.head)


city : Decoder City
city =
    let
        coord =
            decode Coord
                |> required "lon" float
                |> required "lat" float
    in
        decode City
            |> custom (maybe <| field "id" int)
            |> required "name" string
            |> required "coord" coord

forecast : Decoder Forecast
forecast =
    decode Forecast
    |> required "city" city
    |> required "list" (list data)