module Http.Error.View.French exposing (view)

{-| Offre une simple vue en français des erreurs HTTP qui se sont produites.

L'objectif est de fournir des messages destinés à l'utilisateur et qui ne soient pas trop techniques.

@docs view

-}

import Http exposing (Error(..))
import Html exposing (Html)


errorToFrench : Http.Error -> String
errorToFrench error =
    case error of
        BadUrl url ->
            "L'URL fournie n'est pas valide : " ++ url ++ "."

        Timeout ->
            "Le serveur n'as pas répondu à temps (la requête a expirée)."

        NetworkError ->
            "Impossible d'établir une connexion. Votre réseau fonctionne-t-il?"

        BadStatus response ->
            responseToFrench response

        BadPayload errorMessage response ->
            "L'erreur suivante s'est produite : \""
                ++ errorMessage
                ++ "\" et "
                ++ responseToFrench response


responseToFrench : Http.Response String -> String
responseToFrench response =
    "La tentative de connexion à "
        ++ response.url
        ++ " à renvoyer le code d'erreur suivant : "
        ++ toString response.status.code
        ++ " qui correspond à : \""
        ++ response.status.message
        ++ "\"."


{-| Transform un Http.Error en une vue Html

    view (BadUrl "blob")
        --> Html.text "L'URL fournie n'est pas valide : blob"

    view Timeout
        --> Html.text "Le serveur n'as pas répondu à temps (la requête a expirée)."

    view NetworkError
        --> "Impossible d'établir une connexion. Votre réseau fonctionne-t-il?"

    view (BadStatus { url = "http://blob.com", status = { code = 500, message = "oops"}})
        --> Html.text "La tentative de connexion à http://blob.com"
        --> " à renvoyer le code d'erreur suivant : 500"
        --> " qui correspond à : \"oops\""


    view (BadPayload (("no such field name")) { url = "http://blob.com", status = { code = 505, message = "oops"}})
        --> Html.text "L'erreur suivante s'est produite:  no such field name"
        --> " et La tentative de connexion à http://blob.com"
        --> " à renvoyer le code d'erreur suivant : 505"
        --> " qui correspond à : \"oops\""

-}
view : Http.Error -> Html msg
view error =
    errorToFrench error
        |> Html.text
