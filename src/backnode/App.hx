package backnode;

import js.html.Element;
import Externs;

@:expose('backnode.App')
class App {
  public function new (element: Element) {
    trace('new App # ', element.id);
    var stage = new Stage(element);
    stage.setSize(10, 10);
    stage.setUrl('http://www.silexlabs.org');
  };
}
