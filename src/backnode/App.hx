package backnode;

import js.html.Element;

@:expose('backnode.App')
class App {
  public function new (element: Element) {
    trace('new App #', element.id);
  };
}
