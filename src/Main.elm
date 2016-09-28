module Main exposing (..)

import Html exposing (Html, div, input, text, form, button)
import Html.App exposing (program)
import Html.Attributes exposing (value, id)
import Html.Events exposing (onInput, onSubmit)
import Dom
import Task


main : Program Never
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { text : String
    , messages : List Message
    }


type alias Message =
    { text : String
    }


type Msg
    = Noop
    | ChangeText String
    | SendMessage


init : ( Model, Cmd a )
init =
    ( Model "" [], Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ form [ onSubmit SendMessage ]
            [ input [ value model.text, onInput ChangeText, id "input1" ] []
            , button [] [ text "Send" ]
            ]
        , div [] (List.map (\m -> div [] [ text m.text ]) model.messages)
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Noop ->
            ( model, Cmd.none )

        ChangeText text ->
            ( { model | text = text }, Cmd.none )

        SendMessage ->
            ( { model
                | text = ""
                , messages = model.messages ++ [ Message model.text ]
              }
            , Task.perform (always Noop) (always Noop) (Dom.focus "input1")
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
