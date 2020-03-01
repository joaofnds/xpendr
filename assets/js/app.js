import "../css/app.css"
import { Elm } from "../elm/src/Xpendr.elm"

const ElmMainElement = document.getElementById('elm-main')
if (ElmMainElement) {
  Elm.Xpendr.init({ node: ElmMainElement })
}