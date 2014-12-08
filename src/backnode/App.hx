package backnode;

import js.html.Element;
import Externs;

@:expose('backnode.App')
class App {
  public function new (element: Element) {
    // wysiwyg
    var wysiwyg = new Wysiwyg();
    wysiwyg.setSelectionMode(true);
    wysiwyg.setOnSelect(function() {
      var elements = wysiwyg.getSelected();
      trace('selected: ', elements);
    });

    // stage
    var stage = new Stage(element);
    stage.setUrl('thinksimple/').then(function(doc) {
      wysiwyg.setContainer(doc.body);
      return doc;
    })/*.catch(function(e) {
      trace('error!', e);
    })*/;
  };
}
