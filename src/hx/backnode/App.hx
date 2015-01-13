package backnode;

import haxe.Http;
import haxe.Json;

import js.html.DOMWindow;
import js.html.Element;
import js.html.Event;

import Externs;
import js.html.TextAreaElement;
import backnode.views.ToolsView;
import backnode.views.StageView;
import backnode.model.State;

@:expose('backnode.App')
class App {

    public var ce: CloudExplorer;
    public var stage: Stage;
    public var stageView: StageView;
    public var tools: ToolsView;
    public var wysiwyg: Wysiwyg;
    public var fileSelected: CEBlob;

    private var stageWindow:DOMWindow;
    private var editorInstances:Array<Editor>;

    public function new (element: Element) {
        initCE('ce-js');
        initStage(element);
        initTools();
        editorInstances = new Array<Editor>();
    }

    // https://github.com/silexlabs/cloud-explorer
    private function initCE(id: String): Void {
        ce = CloudExplorer.get(id);
    }

    // https://github.com/silexlabs/responsize
    private function initStage(element: Element): Void {
        stage = new Stage(element);
        wysiwyg = new Wysiwyg();
        stageView = new StageView();

        // re set stage size when a window resize event append (or click on size selection)
        stageView.onSizeChange(function(size: {w: Int, h: Int}): Void {
            stage.setSize(size.w, size.h);
        });

        // set initial size
        stage.setSize(element.offsetWidth, element.offsetHeight);
    }

    private function initTools(): Void {
        tools = new ToolsView();

        // Just import button
        tools.state = State.INIT;

        // when a click append on import button
        tools.onOpen(function(e: Event): Void {
            ce.pick(onFileSelected, onError);
        });

        // when a click append on cancel button
        tools.onCancel(function(e: Event): Void {
            onFileSelected(fileSelected);
        });

        tools.onStartEdition(function(isEditionOn: Bool){
            if (isEditionOn) {
                makeFieldEditable();
            }
            else {
                for (inst in editorInstances)
                    inst.destroy();
            }
            stageWindow.document.body.classList.toggle("edition-on");
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
            editorInstances.push(untyped __js__("CKEDITOR.inline(elem);"));
        }

        wysiwyg.setOnSelect(function(){
            var selected = wysiwyg.getSelected();
            selected[0].focus();
        });
    }

    private function onFileSelected(blob: CEBlob): Void {
        fileSelected = blob;
        // set Stage url from Cloud Explorer blob
        stage.setUrl(fileSelected.url).then(function(doc) {
            wysiwyg.setDocument(doc);
            // Store iframe window
            stageWindow = doc.defaultView;
            wysiwyg.addTempStyle("http://localhost:6969/editor.css");

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
