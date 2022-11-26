module Main exposing (..)

import Browser
import Css exposing (..)
import Html
import Html.Styled exposing (Html, div, text, h1, input, button, textarea, toUnstyled, hr)
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
    ,cardTitle : String
    ,contents : String
  }

iniCard = {
  cardId = "000"
  ,boardId = "0"
  ,writerId = "0"
  ,cardTitle = ""
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
  | UpdateCardContents String
  | UpdateWriterName String
  | RegisterCard


update : Msg -> Board -> Board
update msg board = 
  case msg of
    UpdateBoardTitle t ->
      { board | boardTitle = t }
    UpdateCardTitle t ->
      let cCard = board.currentCard in
      let uCard = { cCard | cardTitle = t } in
      { board | currentCard = uCard }
    UpdateCardContents c ->
      let cCard = board.currentCard in
      let uCard = { cCard | contents = c } in
      { board | currentCard = uCard }
    RegisterCard ->
      { board | cardLst = board.currentCard :: board.cardLst}

    _ -> board



-- VIEW


view : Board -> Html Msg
view board =
  div theme.body
    [ div theme.main [ 
        h1 [] [text "寄せ書きしよう" ]
      , viewTitle board
      , button [ onClick CreateBoard ] [ text "Board++" ]
      , div [] [ viewCard board.currentCard]
      , div [] (List.map viewCard board.cardLst)
      ]
    ]


viewInput : String -> String -> String -> (String -> msg) -> Html msg
viewInput t p v toMsg =
  input [ type_ t, placeholder p, value v, onInput toMsg ] []

viewCard : Card -> Html Msg
viewCard card = 
  let cardTitleTheme = (onInput UpdateCardTitle) :: (value card.cardTitle) :: theme.cardTitle in
  let cardContentsTheme = (value card.contents) :: (onInput UpdateCardContents) :: theme.cardContents in
  let cardButtonTheme = (onClick RegisterCard) :: theme.cardButton in
  div theme.card [
          div [] [ input cardTitleTheme [] ]
        , hr [] []
        , div [] [ textarea cardContentsTheme [] ]
        , div [] [ button cardButtonTheme [ text "完成" ]] ]

viewTitle : Board -> Html Msg
viewTitle board = 
  let boardTitleTheme = (onInput UpdateBoardTitle) :: (value board.boardTitle) :: theme.boardTitle in
  div [] [input boardTitleTheme []]

-- Style
type alias Theme =
  { body : List (Html.Styled.Attribute Msg)
    , main : List (Html.Styled.Attribute Msg)
    , card : List (Html.Styled.Attribute Msg)
    , cardContents : List (Html.Styled.Attribute Msg)
    , cardTitle : List (Html.Styled.Attribute Msg)
    , cardButton : List (Html.Styled.Attribute Msg)
    , boardTitle : List (Html.Styled.Attribute Msg)
  }


theme : Theme
theme =
  { body = [ style "background-color" "AliceBlue"
            , style "width" "100vw"
            , style "height" "100vh"
            , style "font-family" "'Kiwi Maru'"
            , style "padding" "10px" ]
    , main = [ style "display" "block"
              , style "margin-left" "auto"
              , style "margin-right" "auto"
              , style "background-color" "White"
              , style "width" "60vw"
              , style "height" "90vh"
              , style "padding" "5px"
              , style "text-align" "center" ]
    , card = [ style "width" "300px"
              , style "height" "320px"
              -- , style "background-color" "#ede4e1"
              , style "padding" "10px"
              , style "margin" "5px"
              , style "border" "solid"
              , style "border-color" "#ADADC9"
              , style "border-radius" "5px"
              , style "float" "left" ]
    , cardContents = [ placeholder "カードの中身"
                      , style "width" "100%"
                      , style "height" "230px"
                      , style "border" "none"
                      , style "margin" "1px"
                      -- , style "background" "yellow"
                      , style "outline" "none"
                      , style "resize" "none" ]
    , cardTitle = [ type_ "text"
                  , placeholder "カードのタイトル"
                  , style "width" "100%"
                  , style "border" "none"
                  , style "margin" "5px"
                  , style "background" "transparent"
                  , style "outline" "none" ]
    , cardButton = [ style "width" "250px"
                   , style "border" "none"
                   , style "border-radius" "10px"
                   , style "background" "PowderBlue"
                   ]
    , boardTitle = [ type_ "text"
                   , placeholder "ボードのタイトル"
                   , style "width" "200px"
                   , style "border" "solid"
                   , style "border-color" "#ADADC9"
                   , style "border-radius" "5px"]
  }