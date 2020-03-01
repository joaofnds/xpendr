import "../css/app.css"
import { Elm } from "../elm/src/Program/Xpendr.elm"

const ElmMainElement = document.getElementById('elm-main')
if (ElmMainElement) {
  Elm.Program.Xpendr.init({ node: ElmMainElement })
}