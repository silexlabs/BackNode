package backnode;

import haxe.Http;
import haxe.Json;

import js.html.Element;
import js.html.Event;

import Externs;
import backnode.views.Tools;
import backnode.views.StageView;
import backnode.model.State;

@:expose('backnode.App')
class App {

    public var ce: CloudExplorer;
    public var stage: Stage;
    public var stageView: StageView;
    public var tools: Tools;
    public var wysiwyg: Wysiwyg;

    public function new (element: Element) {
        /*var wysiwyg = new Wysiwyg();
        wysiwyg.setSelectionMode(true);
        var curElement = null;
        wysiwyg.setOnSelect(function() {
            var elements = wysiwyg.getSelected();
            for(element in elements) {
                if (element.getAttribute("data-bn") == "text"){
                    element.setAttribute("contenteditable", "true");
                    element.style.backgroundColor = "green";
                    if(curElement != null){
                        //   if (curElement != element)
                        //  curElement.removeAttribute("contenteditable");
                        curElement.style.backgroundColor = "";
                    }
                    curElement = element;
                } else {
                    element.style.backgroundColor = "red";
                    if(curElement != null)
                        curElement.style.backgroundColor = "";
                    curElement = element;
                }
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
        http.request();*/

        initCE('ce-js');
        initStage(element);
        initTools();
    };

    private function initCE(id: String): Void {
        ce = CloudExplorer.get(id);
    }

    private function initStage(element: Element): Void {
        stage = new Stage(element);
        wysiwyg = new Wysiwyg();
        stageView = new StageView();

        stageView.onSizeChange(function(size: {w: Int, h: Int}): Void {
            stage.setSize(size.w, size.h);
        });

        stage.setSize(element.offsetWidth, element.offsetHeight);
    }

    private function initTools(): Void {
        tools = new Tools();
        tools.state = State.INIT;
        tools.onOpen(function(e: Event): Void {
            ce.pick(onFileSelected, onError);
        });
    }

    private function onFileSelected(blob: CEBlob): Void {
        trace(blob);
        stage.setUrl(blob.url).then(function(doc) {
            wysiwyg.setContainer(doc.body);
            return doc;
        });
        tools.state = State.FILE_SELECTED;
    }

    private function onError(e: Dynamic): Void {
        try {
            trace("Error: " + Json.stringify(e));
        } catch (e: Dynamic) {
            trace("Error undefined");
        }
    }
}
