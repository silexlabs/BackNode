package backnode;

import haxe.Http;
import haxe.Json;

import js.html.DOMWindow;
import js.html.Element;
import js.html.Event;

import Externs;
import js.html.ImageElement;
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

        // only display import button
        tools.state = State.INIT;

        // when a click append on import button
        tools.onOpen(function(e: Event): Void {
            ce.pick(onFileSelected, onError);
        });

        // when a click append on cancel button
        tools.onCancel(function(e: Event): Void {
            makeFieldEditable(false);
            tools.switchEdition(false);
            onFileSelected(fileSelected);
        });

        // when a click append on save button
        tools.onSave(function(e: Event) {
            makeFieldEditable(false);
            tools.switchEdition(false);

            var content: String = stageWindow.document.head.innerHTML + stageWindow.document.body.innerHTML;
            ce.write(fileSelected, content, function(b: CEBlob){
                //stageWindow.alert("file saved!");
                trace("file saved!");
            }, function(e: Dynamic){
                //stageWindow.alert("error!");
                trace("Error: "+e);
            });
        });

        tools.onStartEdition(makeFieldEditable);
    }

    private inline function makeFieldEditable(editable: Bool):Void
    {
        // first call
        if (editorInstances.length == 0) {
            initFieldEditable();
        }

        for (node in stageWindow.document.querySelectorAll("[data-bn=text]")){
            var elem: Element = cast node;
            elem.contentEditable = Std.string(editable);
            if (editable) {
                // Activate CKEditor inline edition
                editorInstances.push(untyped __js__("CKEDITOR.inline(elem)"));
            }
        }

        if (!editable) {
            for (inst in editorInstances) {
                inst.destroy();
            }
            // reset array, calling destroy on a previous destroyed instance throw an error
            editorInstances = new Array<Editor>();
        }

        stageWindow.document.body.classList.toggle("edition-on");
    }

    private function initFieldEditable(): Void {
        // Let edition only with code activation
        CKEditor.disableAutoInline = true;
        // Activate Wysiwyg selection
        wysiwyg.setSelectionMode(true);
        // Fix ?
        wysiwyg.setOnSelect(function(){
            var selected = wysiwyg.getSelected();
            selected[0].focus();

            if(selected[0].tagName.toLowerCase() == "img" && selected[0].hasAttribute("data-bn") && selected[0].getAttribute("data-bn") == "img"){
                ce.pick(function(blob: CEBlob){
                    var img: ImageElement = cast selected[0];
                    img.src = blob.url;
                    }, onError);
            }
        });
    }

    private function onFileSelected(blob: CEBlob): Void {
        fileSelected = blob;
        // set Stage url from Cloud Explorer blob
        stage.setUrl(fileSelected.url).then(function(doc) {
            wysiwyg.setDocument(doc);
            // Store iframe window
            stageWindow = doc.defaultView;
            wysiwyg.addTempStyle("/editor.css");

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
