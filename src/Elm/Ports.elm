port module Ports exposing (getCityList, updateCityList, returnCityList)

import Weather exposing (City)

port getCityList_ : () -> Cmd msg
port updateCityList : List City -> Cmd msg

port returnCityList : (List City -> msg) -> Sub msg

getCityList : Cmd msg
getCityList =
    getCityList_ ()