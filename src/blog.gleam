import gleam/uri.{type Uri}
import lustre
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import lustre/effect.{type Effect}
import modem

pub fn main() {
  let app = lustre.application(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)
  Nil
}

pub type Route {
  Home
  Bio
}

fn init(_) -> #(Route, Effect(Msg)) {
  #(Home, modem.init(on_url_change))
}

fn on_url_change(uri: Uri) -> Msg {
  case uri.path_segments(uri.path) {
    ["home"] -> OnRouteChange(Home)
    ["bio"] -> OnRouteChange(Bio)
    _ -> OnRouteChange(Home)
  }
}

pub type Msg {
  OnRouteChange(Route)
}

fn update(_, msg: Msg) -> #(Route, Effect(Msg)) {
  case msg {
    OnRouteChange(route) -> #(route, effect.none())
  }
}

fn view(route: Route) -> Element(Msg) {
  html.div([], [
    html.nav([], [
      html.a([attribute.href("/home")], [element.text("Go to home")]),
      html.a([attribute.href("/bio")], [element.text("Go to bio")]),
    ]),
    case route {
      Home -> html.h1([], [element.text("You're home")])
      Bio -> html.h1([], [element.text("You're on bio")])
    },
  ])
}