module Weather exposing (..)

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
    , country : String
    }


type alias Temp =
    { temp : Float
    , minTemp : Float
    , maxTemp : Float
    , humidity : Float
    }


type alias Weather =
    { id : Int
    , name : String
    , description : String
    }


type alias Data =
    { time : Float 
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
        |> custom (field "temp" float |> Decode.map ((+) -273.15))
        |> custom (field "temp_min" float |> Decode.map ((+) -273.15))
        |> custom (field "temp_max" float |> Decode.map ((+) -273.15))
        |> required "humidity" float


weather : Decoder Weather
weather =
    decode Weather
        |> required "id" int
        |> required "main" string
        |> required "description" string


data : Decoder Data
data =
    decode Data
        |> custom (field "dt" float |> Decode.map ((*) 1000))
        |> required "main" temp
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
            |> required "country" string

forecast : Decoder Forecast
forecast =
    decode Forecast
    |> required "city" city
    |> required "list" (list data)