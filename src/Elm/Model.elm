module Model exposing (..)

import Http exposing (..)
import Weather exposing (..)
import Material


type alias Model =
    { forecasts : List Forecast
    , query : String
    , isError : Bool
    , mdl : Material.Model
    }


type Msg
    = GetForecast (Result Http.Error Forecast) -- APIから天気予報を取得する
    | InputQuery String -- 都市名の入力を受け付ける
    | GetCityList -- WebStrageから都市のリストを取得
    | ReturnCityList (List City) -- WebStrageからの都市リストを返却
    | AddCity -- 都市の追加
    | UpdateCityList (List City) -- 都市リストの更新をJS側に伝える
    | RemoveCity Int -- 都市の削除
    | Mdl (Material.Msg Msg)


init : Model
init =
    { forecasts = []
    , query = ""
    , isError = False
    , mdl = Material.model
    }