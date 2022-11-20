module Main exposing (..)

import Browser
import Css exposing (..)
import Html
--exposing (Html, Attribute, div, input, text, button)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, style, checked, class, for, id, name, type_, value, placeholder)
import Html.Styled.Events exposing (onInput, onClick)


-- MAIN

main : Program () Board Msg
main =
  Browser.sandbox { init = init, update = update, view = view >> toUnstyled }



-- MODEL


--type Model
--  = Model { boards : List Board }
-- type alias Model = Board

type alias Board = {
      boardId : String
      ,creatorId : String
      ,cardLst : List Card
      ,boardTitle : String
      ,currentCard : Card
  }

type Writer
  = Writer {
      writerId : String
      ,name : String
  }

type alias Card = {
    cardId : String
    ,boardId : String
    ,writerId : String
    ,title : String
    ,contents : String
  }

iniCard = {
  cardId = "000"
  ,boardId = "0"
  ,writerId = "0"
  ,title = ""
  ,contents = ""
  }

init : Board
init = { 
  boardId = "0"
  ,boardTitle = ""
  ,creatorId = "0"
  ,cardLst = []
  ,currentCard = iniCard
  }



-- UPDATE


type Msg
  = CreateBoard
  | CreateCard
  | UpdateCardTitle String
  | UpdateBoardTitle String
  | UpdateCardContent String


update : Msg -> Board -> Board
update msg board = 
  case msg of
    UpdateBoardTitle boardTitle ->
      {board | boardTitle = boardTitle}
    -- UpdateCardTitle cardTitle ->
    --  {board | currentCard.title = cardTitle}
    _ -> board



-- VIEW


view : Board -> Html Msg
view board =
  let cCard = board.currentCard in
  div [style "background-color" "red"]
    [ div [] [ text "感謝の気持ちを伝えよう" ]
      , viewInput "text" "ボードのタイトル" board.boardTitle UpdateBoardTitle
      , button [ onClick CreateBoard ] [ text "Board++" ]
      , div [] [ viewInput "text" "カードのタイトル" cCard.title UpdateCardTitle]
      , div [] [ viewInput "text" "カードの中身" cCard.contents UpdateCardContent]
      , button [ onClick CreateCard ] [ text "Card++" ]
    ]


viewInput : String -> String -> String -> (String -> msg) -> Html msg
viewInput t p v toMsg =
  input [ type_ t, placeholder p, value v, onInput toMsg ] []


-- Style
type alias Theme =
  { background : {default : Color }
  }


theme : Theme
theme =
  { background = {default = rgb 0 255 0 }
  }