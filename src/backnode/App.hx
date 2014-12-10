package backnode;

import js.html.Element;
import Externs;
import ce.api.CloudExplorer;

@:expose('backnode.App')
class App {
  public function new (element: Element) {
    // wysiwyg
    var wysiwyg = new Wysiwyg();
    wysiwyg.setSelectionMode(true);
      var curElement = null;
    wysiwyg.setOnSelect(function() {
      var elements = wysiwyg.getSelected();
      trace('selected: ', elements);
      for(element in elements) {
        trace(element.getAttribute("data-bn"));
        if (element.getAttribute("data-bn") == "text"){
         element.setAttribute("contenteditable", "true");
         element.style.backgroundColor="green";
         if(curElement != null){
        //   if (curElement != element)
          //  curElement.removeAttribute("contenteditable");
          curElement.style.backgroundColor="";
         }
         curElement = element;
        } else {
          element.style.backgroundColor="red";
         if(curElement != null)
          curElement.style.backgroundColor="";
         curElement = element;
        }
      }
    });

    // stage
    var stage = new Stage(element);
    stage.setSize(1000, 1000);
    stage.setUrl('/api/1.0/dropbox/exec/get/templates-html5/grungeset/index.html').then(function(doc) {
      wysiwyg.setContainer(doc.body);
      return doc;
    })/*.catch(function(e) {
      trace('error!', e);
    })*/;
  };
}
