import Http
import Html exposing (..)
import Html.Attributes exposing (placeholder, src, type_)
import Html.Events exposing (onClick, onInput)
import Json.Decode exposing (Decoder)
main =
  Html.program
    { init = init "cats"
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



  -- Model

type alias Model =
  { topic : String
  , gifUrl : String
  , error : String
  }


init : String -> (Model, Cmd Msg)
init topic =
  ( Model topic "waiting.gif" "test"
  , getRandomGif topic
  )
-- UPDATE

type Msg = MorePlease
 | NewGif (Result Http.Error String)
 | Topic String

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    MorePlease ->
      (model, getRandomGif model.topic)

    NewGif (Ok newUrl) ->
      ( { model | gifUrl = newUrl }, Cmd.none)

    NewGif (Err err) ->
      ({ model | error = toString err}, Cmd.none)

    Topic topic ->
      ({ model |topic = topic}, Cmd.none)

-- VIEW

view : Model -> Html Msg
view model =
 div []
    [ h2 [] [text model.topic]
    , button [ onClick MorePlease ] [ text "More Please!" ]
    ,  input [ type_ "text", placeholder "Topic", onInput Topic ] []
    , br [] []
    , img [src model.gifUrl] []
        , div [] [ text (model.error) ]
    ]


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

getRandomGif : String -> Cmd Msg
getRandomGif topic =
  let
    url =
      "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ topic

    request =
      Http.get url decodeGifUrl
  in
    Http.send NewGif request

decodeGifUrl : Decoder String
decodeGifUrl =
  Json.Decode.at ["data", "image_url"] Json.Decode.string