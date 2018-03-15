module Model exposing (..)

import Http exposing (..)
import Weather exposing (..)
import Geocode exposing (..)
import Material


type alias Forecast =
    { geocode : Geocode
    , list : List Data
    }


type alias Model =
    { forecasts : List Forecast
    , query : String
    , isError : Bool
    , mdl : Material.Model
    }


type Msg
    = GetForecast Geocode (Result Http.Error (List Data)) -- APIから天気予報を取得する
    | GetGeocode (Result Http.Error Geocode)
    | InputQuery String -- 都市名の入力を受け付ける
    | GetCityList -- WebStrageから都市のリストを取得
    | ReturnGeocodeList (List Geocode) -- WebStrageからの都市リストを返却
    | AddCity -- 都市の追加
    | UpdateGeocodeList (List Geocode) -- 都市リストの更新をJS側に伝える
    | RemoveCity Int -- 都市の削除
    | Mdl (Material.Msg Msg)


init : Model
init =
    { forecasts = []
    , query = ""
    , isError = False
    , mdl = Material.model
    }