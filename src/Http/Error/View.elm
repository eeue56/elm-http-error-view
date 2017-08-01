module Http.Error.View exposing (view)

{-| Provide a simple English view for when a network error happens via HTTP

This is intended to be user-friendly and not give too much techinical info to the user.

@docs view

-}

import Http exposing (Error(..))
import Html exposing (Html)


errorToEnglish : Http.Error -> String
errorToEnglish error =
    case error of
        BadUrl url ->
            "I was expecting a valid URL, but I got the url: " ++ url

        Timeout ->
            "It took too long to get a response from the server!"

        NetworkError ->
            "Unable to make a connection. Is your network working?"

        BadStatus response ->
            responseToEnglish response

        BadPayload errorMessage response ->
            "I failed because of the following error: "
                ++ errorMessage
                ++ " and "
                ++ responseToEnglish response


responseToEnglish : Http.Response String -> String
responseToEnglish response =
    "I tried to connect to "
        ++ response.url
        ++ " but the response gave me the error code: "
        ++ toString response.status.code
        ++ " which is known as: \""
        ++ response.status.message
        ++ "\"."


{-| Turn a Http.Error into a Html view

    view (BadUrl "blob")
        --> Html.text "I was expecting a valid URL, but I got the url: blob"

    view Timeout
        --> Html.text "It took too long to get a response from the server!"

    view NetworkError
        --> "Unable to make a connection. Is your network working?"

    view (BadStatus { url = "http://blob.com", status = { code = 500, message = "oops"}})
        --> Html.text "I tried to connect to http://blob.com"
        --> " but the response gave me the error code 500"
        --> " which is known as \"oops\""


    view (BadPayload (("no such field name")) { url = "http://blob.com", status = { code = 505, message = "oops"}})
        --> Html.text "I failed because of no such field name"
        --> " and I tried to connect to http://blob.com"
        --> " but the response gave me the error code 505"
        --> " which is known as \"oops\""

-}
view : Http.Error -> Html msg
view error =
    errorToEnglish error
        |> Html.text
