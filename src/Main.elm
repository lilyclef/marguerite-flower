module Main exposing (..)

-- Press buttons to increment and decrement a counter.
--
-- Read how it works:
--   https://guide.elm-lang.org/architecture/buttons.html
--


import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)



-- MAIN


main =
  Browser.sandbox { init = init, update = update, view = view }



-- MODEL


--type Model
--  = Model { boards : List Board }
-- type alias Model = Board

type alias Board = {
      boardId : String
      ,creatorId : String
      ,cardLst : List Card
      ,boardTitle : String
  }

type Writer
  = Writer {
      writerId : String
      ,name : String
  }

type Card
  = Card {
    cardId : String
    ,boardId : String
    ,writerId : String
    ,title : String
    ,contents : String
  }

init : Board
init = { 
  boardId = "0"
  ,boardTitle = ""
  ,creatorId = "0"
  ,cardLst = []
  }



-- UPDATE


type Msg
  = CreateBoard
  | CreateCard
  | UpdateCardTitle String
  | UpdateBoardTitle String


update : Msg -> Board -> Board
update msg board = 
  case msg of
    UpdateBoardTitle boardTitle ->
      {board | boardTitle = boardTitle}
    _ -> board



-- VIEW


view : Board -> Html Msg
view board =
  div []
    [ div [] [ text "感謝の気持ちを伝えよう" ]
      ,viewInput "text" "ボードのタイトル" board.boardTitle UpdateBoardTitle
    
    ]


viewInput : String -> String -> String -> (String -> msg) -> Html msg
viewInput t p v toMsg =
  input [ type_ t, placeholder p, value v, onInput toMsg ] []
