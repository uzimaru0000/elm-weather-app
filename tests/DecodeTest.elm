module DecodeTest exposing (..)

import Weather as Weather
import Test exposing (Test, describe, test)
import TestExp exposing (..)
import Json.Decode as Decode


tempJson : String
tempJson =
    """
    {
        "temp": 298.77,
        "temp_min": 298.77,
        "temp_max": 298.774,
        "pressure": 1005.93,
        "sea_level": 1018.18,
        "grnd_level": 1005.93,
        "humidity": 87,
        "temp_kf": 0.26
    }
    """


tempResult : Weather.Temp
tempResult =
    { temp = 298.77
    , minTemp = 298.77
    , maxTemp = 298.774
    , humidity = 87
    }


weatherJson : String
weatherJson =
    """
    {
        "id": 804,
        "main": "Clouds",
        "description": "overcast clouds",
        "icon": "04d"
    }
    """


weatherResult : Weather.Weather
weatherResult =
    { id = 804
    , name = "Clouds"
    , description = "overcast clouds"
    }


dataJson : String
dataJson =
    """
    {
        "dt": 1406106000,
        "main": {
            "temp": 298.77,
            "temp_min": 298.77,
            "temp_max": 298.774,
            "pressure": 1005.93,
            "sea_level": 1018.18,
            "grnd_level": 1005.93,
            "humidity": 87,
            "temp_kf": 0.26
        },
        "weather": [
            {
                "id": 804,
                "main": "Clouds",
                "description": "overcast clouds",
                "icon": "04d"
            }
        ],
        "clouds": {
            "all": 88
        },
        "wind": {
            "speed": 5.71,
            "deg": 229.501
        },
        "sys": {
            "pod": "d"
        },
        "dt_txt": "2014-07-23 09:00:00"
    }
    """


dataResult : Weather.Data
dataResult =
    { time = 1406106000
    , temp = tempResult
    , weather = [ weatherResult ]
    }


cityJson : String
cityJson =
    """
    {
        "id": 1851632,
        "name": "Shuzenji",
        "coord": {
            "lon": 138.933334,
            "lat": 34.966671
        },
        "country": "JP"
    }
    """


cityResult : Weather.City
cityResult =
    { id = 1851632
    , name = "Shuzenji"
    , coord = { lon = 138.933334, lat = 34.966671 }
    , country = "JP"
    }


forecastJson : String
forecastJson =
    """
    {
        "city": {
            "id": 1851632,
            "name": "Shuzenji",
            "coord": {
                "lon": 138.933334,
                "lat": 34.966671
            },
            "country": "JP"
        },
        "cod": "200",
        "message": 0.0045,
        "cnt": 38,
        "list": [
            {
                "dt": 1406106000,
                "main": {
                    "temp": 298.77,
                    "temp_min": 298.77,
                    "temp_max": 298.774,
                    "pressure": 1005.93,
                    "sea_level": 1018.18,
                    "grnd_level": 1005.93,
                    "humidity": 87,
                    "temp_kf": 0.26
                },
                "weather": [
                    {
                        "id": 804,
                        "main": "Clouds",
                        "description": "overcast clouds",
                        "icon": "04d"
                    }
                ],
                "clouds": {
                    "all": 88
                },
                "wind": {
                    "speed": 5.71,
                    "deg": 229.501
                },
                "sys": {
                    "pod": "d"
                },
                "dt_txt": "2014-07-23 09:00:00"
            }
        ]
    }
    """

forecastResult : Weather.Forecast
forecastResult =
    { city = cityResult
    , list = [ dataResult ]
    }


decodeTest : Test
decodeTest =
    describe "City Decode"
        [ "Temp"
            => let
                result =
                    Decode.decodeString Weather.temp tempJson
               in
                result === (Ok tempResult)
        , "Weather"
            => let
                result =
                    Decode.decodeString Weather.weather weatherJson
               in
                result === (Ok weatherResult)
        , "Data"
            => let
                result =
                    Decode.decodeString Weather.data dataJson
               in
                result === (Ok dataResult)
        , "City"
            => let
                result =
                    Decode.decodeString Weather.city cityJson
               in
                result === (Ok cityResult)
        , "Forecast"
            => let
                result =
                    Decode.decodeString Weather.forecast forecastJson  
            in
                result === (Ok forecastResult)
        ]
