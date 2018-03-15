port module Ports exposing (getGeocodeList, updateGeocodeList, returnGeocodeList)

import Geocode exposing (Geocode)

port getGeocodeList_ : () -> Cmd msg
port updateGeocodeList : List Geocode -> Cmd msg

port returnGeocodeList : (List Geocode -> msg) -> Sub msg

getGeocodeList : Cmd msg
getGeocodeList =
    getGeocodeList_ ()