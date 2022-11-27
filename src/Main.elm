module Main exposing (..)

import Browser
import Css exposing (..)
import Html
import Html.Styled exposing (Html, div, text, h1, input, button, textarea, toUnstyled, hr, br)
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

type Mode = InitMode | MessageMode

type alias Board = {
      boardId : String
      ,creatorId : String
      ,cardLst : List Card
      ,boardTitle : String
      ,inputCard : Card
      ,mode : Mode
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
    ,writerName : String
    ,contents : String
  }

iniCard = {
  cardId = "000"
  ,boardId = "0"
  ,writerId = "0"
  ,writerName = ""
  ,contents = ""
  }

init : Board
init = { 
  boardId = "0"
  ,boardTitle = ""
  ,creatorId = "0"
  ,cardLst = []
  ,inputCard = iniCard
  ,mode = InitMode
  }



-- UPDATE


type Msg
  = RegisterBoard
  | UpdateWriterName String
  | UpdateBoardTitle String
  | UpdateCardContents String
  | RegisterCard


update : Msg -> Board -> Board
update msg board = 
  case msg of
    RegisterBoard -> { board | mode = MessageMode }
    UpdateBoardTitle t ->
      { board | boardTitle = t }
    UpdateWriterName t ->
      let inCard = board.inputCard in
      let uCard = { inCard | writerName = t } in
      { board | inputCard = uCard }
    UpdateCardContents c ->
      let inCard = board.inputCard in
      let uCard = { inCard | contents = c } in
      { board | inputCard = uCard }
    RegisterCard ->
      { board | cardLst = board.inputCard :: board.cardLst, inputCard = iniCard}



-- VIEW


view : Board -> Html Msg
view board =
  let boardInternal = if board.mode == InitMode then (viewTitle board) else (viewInputCard board.inputCard) in
  div theme.body
    [ div theme.main [ 
        h1 [] [text "寄せ書きしよう" ]
        , boardInternal
        , div [] (List.map viewCard board.cardLst)
      ]
    ]


viewInput : String -> String -> String -> (String -> msg) -> Html msg
viewInput t p v toMsg =
  input [ type_ t, placeholder p, value v, onInput toMsg ] []

viewInputCard : Card -> Html Msg
viewInputCard card = 
  let writerNameTheme = (style "border" "none") :: (onInput UpdateWriterName) :: (value card.writerName) :: theme.writerName in
  let cardContentsTheme = (value card.contents) :: (onInput UpdateCardContents) :: theme.cardContents in
  let cardButtonTheme = (onClick RegisterCard) :: theme.cardButton in
  div theme.inputCard [
          div [] [ input writerNameTheme [] ]
        , hr [] []
        , div [] [ textarea cardContentsTheme [] ]
        , div [] [ button cardButtonTheme [ text "メッセージを送る" ]] ]

viewTitle : Board -> Html Msg
viewTitle board = 
  let boardTitleTheme = (onInput UpdateBoardTitle) :: (value board.boardTitle) :: theme.boardTitle in
  let buttonTheme = (onClick RegisterBoard) :: theme.cardButton in
  div theme.inputCard [ div theme.boardTitleCover [ div [] [input boardTitleTheme [], text "さんへ"], br[][], br[][], button buttonTheme [ text "寄せ書きを作る" ]]]


viewCard : Card -> Html Msg
viewCard card = 
  div theme.outputCard [
          div [] [ text card.contents ]
        , br [] []
        , div [] [ text card.writerName, text "より" ]]

-- Style


type alias Theme =
  { body : List (Html.Styled.Attribute Msg)
    , main : List (Html.Styled.Attribute Msg)
    , inputCard : List (Html.Styled.Attribute Msg)
    , cardContents : List (Html.Styled.Attribute Msg)
    , writerName : List (Html.Styled.Attribute Msg)
    , cardButton : List (Html.Styled.Attribute Msg)
    , boardTitle : List (Html.Styled.Attribute Msg)
    , boardTitleCover : List (Html.Styled.Attribute Msg)
    , outputCard : List (Html.Styled.Attribute Msg)
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
    , inputCard = [ style "width" "300px"
              , style "height" "320px"
              , style "padding" "10px"
              , style "margin" "5px"
              , style "margin-left" "auto"
              , style "margin-right" "auto"
              , style "border" "solid"
              , style "border-color" "#ADADC9"
              , style "border-radius" "5px"
              , style "display" "block"]
    , cardContents = [ placeholder "メッセージをここに書いてね"
                      , style "width" "100%"
                      , style "height" "230px"
                      , style "border" "none"
                      , style "margin" "1px"
                      , style "outline" "none"
                      , style "resize" "none" ]
    , writerName = [ type_ "text"
                  , placeholder "差出人の名前"
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
                   , placeholder ""
                   , style "width" "150px"
                   , style "border" "none"
                   , style "border-bottom" "dotted"
                   , style "outline" "none"
                   , style "font-size" "20px"]
    , boardTitleCover = [ style "height" "150px"
                        , style "padding" "80px 10px"
                        , style "margin" "10px"]
    , outputCard = [ style "width" "200px"
              , style "height" "100px"
              , style "padding" "10px"
              , style "margin" "10px 10px"
              , style "border" "solid"
              , style "border-color" "#ADADC9"
              , style "border-radius" "5px"
              , style "float" "left"]
  }