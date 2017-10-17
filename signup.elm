import Char
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import String exposing (any)


main =
  Html.beginnerProgram { model = model, view = view, update = update }


-- MODEL

type alias Model =
   { name : String
   , password : String
   , passwordAgain : String
   , age : String
   , validate : Bool
   }


model : Model
model =
  Model "" "" "" "" False


-- UPDATE

type Msg
    = Name String
    | Password String
    | PasswordAgain String
    | Age String
    | Validate


update : Msg -> Model -> Model
update msg model =
  case msg of
    Name name ->
      { model | name = name }

    Password password ->
      { model | password = password }

    PasswordAgain password ->
      { model | passwordAgain = password }

    Age age ->

      { model | age = age }

    Validate ->
      { model | validate = True }



-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ input [ type_ "text", placeholder "Name", onInput Name ] []
    , input [ type_ "password", placeholder "Password", onInput Password ] []
    , input [ type_ "password", placeholder "Re-enter Password", onInput PasswordAgain ] []
    , input [ type_ "text", placeholder "Age", onInput Age ] []
    , button [ onClick Validate ] [ text "Submit"]
    , viewValidation model
    ]



viewValidation : Model -> Html msg
viewValidation model =
  let
    (color, message) =
     if model.validate == True then
      if model.password == model.passwordAgain then
       if String.length model.password >= 8 then
        if any Char.isUpper model.password then
         if any Char.isDigit model.age then
          ("green", "ok")
         else
          ("red", "Age need to be a number ")
        else
         ("red", "need upper")
       else
        ("red", "Passwords not enough long")
      else
        ("red", "Passwords do not match!")
     else
      ("black", "Button not pushed")
  in
    div [ style [("color", color)] ] [ text message ]