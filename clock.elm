import Html exposing (Html, button, div)
import Html.Events exposing (onClick)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time exposing (Time, second)



main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL

type alias Model = { time : Time
   , shouldStop : Bool
   }


init : (Model, Cmd Msg)
init =
 (Model 0 False, Cmd.none)


-- UPDATE

type Msg
  = Tick Time
  | Pause
  | Continue



update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Tick newTime ->
      ( {model | time = newTime}, Cmd.none)
    Pause ->
       ({model | shouldStop = True }, Cmd.none)
    Continue ->
       ({model | shouldStop = False }, Cmd.none)



-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
   if model.shouldStop == True then
     Sub.none
   else
     Time.every second Tick



-- VIEW

view : Model -> Html Msg
view model =
  let
    angle =
      turns (Time.inMinutes model.time)

    handX =
      toString (50 + 40 * cos angle)

    handY =
      toString (50 + 40 * sin angle)
  in
   div []
    [ svg [ viewBox "0 0 100 100", width "300px" ]
      [ circle [ cx "50", cy "50", r "45", fill "#0B79CE" ] []
      , line [ x1 "50", y1 "50", x2 handX, y2 handY, stroke "#023963" ] []
      ]

    , clockButton model ]

clockButton : Model -> Html Msg
clockButton model =
    if model.shouldStop == True then
        button [ onClick Continue ] [ text "Continue"]
    else
        button [ onClick Pause ] [ text "Pause"]
