module Http.Error.View.Welsh exposing (view)

{-| Dangos iaith cyfeillgar i eich defnyddwyr mewn Cymraeg

Mae popeth sy'n gweld fel bod yn rhi tecnegol ddim am dangos i nhw, dim ond negeseuon sy'n helpu.

@docs view

-}

import Http exposing (Error(..))
import Html exposing (Html)


errorToWelsh : Error -> String
errorToWelsh error =
    case error of
        BadUrl url ->
            "Roedd i'n edrych am URL, ond ges i: " ++ url

        Timeout ->
            "Roedd yr wefan cymryd gormod o amswer!"

        NetworkError ->
            "Nac ydw i'n galli cysylltu gyda yr we. Ydy yr we yn gweitho am chi?"

        BadStatus response ->
            responseToWelsh response

        BadPayload errorMessage response ->
            "Mae anffodus ganddo i, ond rwy'n methu gweitho oherwydd: "
                ++ errorMessage
                ++ " ac "
                ++ responseToWelsh response


responseToWelsh : Http.Response String -> String
responseToWelsh response =
    "Fy ceisio cwrdd "
        ++ response.url
        ++ " ond fy ges i yr error code: "
        ++ toString response.status.code
        ++ " sy'n nabod fel: \""
        ++ response.status.message
        ++ "\"."


{-| Trwy Http.Error i Html.

    view (BadUrl "blob")
        --> Html.text "Roedd i'n edrych am URL, ond ges i: blob"

    view Timeout
        --> Html.text "Roedd yr wefan cymryd gormod o amswer!"

    view NetworkError
        --> "Nac ydw i'n galli cysylltu gyda yr we. Ydy yr we yn gweitho am chi?"

    view (BadStatus { url = "http://blob.com", status = { code = 500, message = "oops"}})
        --> Html.text " Fy ceisio cwrdd http://blob.com"
        --> " ond fy ges i yr error code: 500"
        --> " sy'n nabod fel: \"oops\""


    view (BadPayload (("no such field name")) { url = "http://blob.com", status = { code = 505, message = "oops"}})
        --> Html.text "Mae anffodus ganddo i, ond rwy'n methu gweitho oherwydd: no such field name"
        --> " ac Fy ceisio cwrdd http://blob.com"
        --> " ond fy ges i yr error code: 505"
        --> " sy'n nabod fel: \"oops\""

-}
view : Http.Error -> Html msg
view error =
    errorToWelsh error
        |> Html.text
