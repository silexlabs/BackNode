package backnode;

import haxe.Http;
import haxe.Json;

import js.html.Element;

import Externs;
import js.html.TextAreaElement;

@:expose('backnode.App')
class App {
    public function new (element: Element) {
        // wysiwyg
        var wysiwyg = new Wysiwyg();
        wysiwyg.setSelectionMode(true);

        var editor: TextAreaElement = cast js.Browser.document.getElementById("editor");
        var curElement = null;
        wysiwyg.setOnSelect(function() {
            var elements = wysiwyg.getSelected();
            for(element in elements) {
                if (element.getAttribute("data-bn") == "text"){
                    //element.setAttribute("contenteditable", "true");
                    //element.style.backgroundColor = "green";
                    editor.textContent = element.textContent;
                    untyped aloha(editor);
                    editor.nextElementSibling.onclick = function(e){
                        element.textContent = editor.textContent;
                        resetEditor(editor);
                    };
                    editor.nextElementSibling.nextElementSibling.onclick = function(e){
                        resetEditor(editor);
                    };
                    element.style.border = "1px solid green";
                } else {
                    element.style.border = "1px solid red";
                }
                if(curElement != null)
                    curElement.style.border = "";
                curElement = element;
            }
        });

        // Config
        var http = new Http("/templates/templates.json");
        http.onData = function(data){
            var aTemplates: Array<String> = cast Json.parse(data);

             // stage
            var stage = new Stage(element);
            stage.setSize(1000, 1000);
            stage.setUrl(aTemplates[0]).then(function(doc) {
                wysiwyg.setContainer(doc.body);
                return doc;
            });
        }

        http.onError = function(msg){
            trace("Unable to load templates file: " + msg);
        }
        http.request();
    }

    /**
    * Reset Aloha editor by emptying the textContent and disabling edition
    * @param editor: The element acting as the editor to reset
    * @return the editor for chaining purposes
    **/
    private inline function resetEditor(editor: Element):Element
    {
        editor.textContent = "";
        untyped aloha.mahalo(editor);
        return editor;
    }
}
