module DecodeTest exposing (..)

import Weather as Weather
import Date
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
    { time = Date.fromTime 1406106000
    , temp = tempResult
    , weather = Just weatherResult
    }


cityJson : String
cityJson =
    """
    {
        "coord": {
            "lon": 140.1,
            "lat": 39.72
        },
        "weather": [
            {
                "id": 803,
                "main": "Clouds",
                "description": "broken clouds",
                "icon":"04n"
            }
        ],
        "base": "stations",
        "main": {
            "temp": 272.15,
            "pressure": 1021,
            "humidity": 92,
            "temp_min": 272.15,
            "temp_max": 272.15
        },
        "visibility": 10000,
        "wind": {
            "speed": 1.5,
            "deg": 150
        },
        "clouds": {
            "all": 75
        },
        "dt": 1520719200,
        "sys": {
            "type": 1,
            "id": 7597,
            "message": 0.007,
            "country": "JP",
            "sunrise": 1520629102,
            "sunset": 1520671301
        },
        "id": 2113126,
        "name": "Akita",
        "cod":200
    }
    """


cityResult : Weather.City
cityResult =
    { id = Just 2113126
    , name = "Akita"
    , coord = { lon = 140.1, lat = 39.72 }
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
        [ "City"
            => let
                result =
                    Decode.decodeString Weather.city cityJson
               in
                result === (Ok cityResult)
        ]
