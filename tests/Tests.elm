module Tests exposing (..)

import Test exposing (Test, describe)
import TestExp exposing (..)
import DecodeTest as Decode

all : Test
all =
    describe "All Test"
        [ Decode.decodeTest
        ]