module Program.Xpendr exposing (main)

import Browser exposing (Document)
import Html exposing (text)

main :  Program Flags Model Msg
main
    = Browser.document
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }

type alias Flags = {}

type alias Model = {}

type alias Msg = String

init : Flags -> ( Model, Cmd Msg )
init _ = ({}, Cmd.none)

update : Msg -> Model -> ( Model, Cmd Msg)
update msg model =
    case msg of
        _ ->
            ( model, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none

view : Model -> Document msg
view _ =
    Document "Xpendr" [ text "asdf" ]