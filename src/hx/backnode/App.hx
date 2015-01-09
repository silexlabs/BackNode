package backnode;

import haxe.Http;
import haxe.Json;

import js.html.DOMWindow;
import js.html.Element;
import js.html.Event;

import Externs;
import js.html.TextAreaElement;
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

    private var stageWindow:DOMWindow;

    public function new (element: Element) {
        initCE('ce-js');
        initStage(element);
        initTools();
    }

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
        tools.onStartEdition(function(e: Event){
            makeFieldEditable();
        });
    }

    private inline function makeFieldEditable():Void
    {
        // Activate Wysiwyg selection
        wysiwyg.setSelectionMode(true);

        // Let edition only with code activation
        CKEditor.disableAutoInline = true;

        for(node in stageWindow.document.querySelectorAll("[data-bn=text]")){
            var elem: Element = cast node;
            elem.contentEditable = "true";
            // Activate inline edition
            untyped __js__("CKEDITOR.inline(elem);");
        }

        wysiwyg.setOnSelect(function(){
            var selected = wysiwyg.getSelected();
            selected[0].focus();
        });
    }

    private function onFileSelected(blob: CEBlob): Void {
        trace(blob);
        stage.setUrl(blob.url).then(function(doc) {
            wysiwyg.setDocument(doc);
            // Store iframe window
            stageWindow = doc.defaultView;

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
