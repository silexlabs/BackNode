package backnode;

import haxe.Http;
import haxe.Json;

import js.Browser;
import js.html.DOMWindow;
import js.html.Element;
import js.html.Event;

import Externs;
import js.html.DOMElement;
import js.html.IFrameElement;
import js.html.ImageElement;
import js.html.InputElement;
import js.html.TextAreaElement;
import js.html.DivElement;
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
            tools.switchEdition(false);
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
            duplicable(false);
            var content: String = wysiwyg.getCleanHtml();
            ce.write(fileSelected, content, function(b: CEBlob){
                stageWindow.alert("file saved!");
                //trace("file saved!");
            }, function(e: Dynamic){
                stageWindow.alert("error!");
                //trace("Error: "+e);
            });
        });

        tools.onStartEdition(makeFieldEditable);
    }

    private inline function makeFieldEditable(editable: Bool):Void
    {
        // Activate Wysiwyg selection
        wysiwyg.setSelectionMode(editable);

        // first call
	    if (editable) {
            tools.state = EDITION_ON;
            // Let edition only with code activation
            CKEditor.disableAutoInline = true;

            wysiwyg.setOnSelect(function(){
                var selected = wysiwyg.getSelected();
                selected[0].focus();
                if(tools.state == EDITION_ON && selected[0].hasAttribute("data-bn-editable")){
                    switch (selected[0].tagName.toLowerCase()) {
                        case "img":
                            // Pick image on CE
                            ce.pick(function(blob: CEBlob){
                                var img: ImageElement = cast selected[0];
                                img.src = blob.url;
                            }, onError);
                        case "iframe":
                            // Edit src
                            var iframe: IFrameElement = cast selected[0];
                            var popup = Browser.document.getElementById("edition-popup");

                            // Display popup
                            popup.style.top = Browser.window.innerHeight/2 - popup.offsetHeight/2+"px";
                            popup.style.left = Browser.window.innerWidth/2 - popup.offsetWidth/2+"px";
                            popup.style.display = "block";

                            // Default value
                            var srcInput: InputElement = cast popup.querySelector("input[type=text]");
                            srcInput.value = iframe.src;

                            for(button in popup.querySelectorAll("input[type=button]")){
                                cast(button, Element).onclick = function(e: Event) {
                                    if(cast(e.target, Element).classList.contains("save"))
                                        iframe.src = srcInput.value;
                                    // reset style
                                    popup.removeAttribute("style");
                                };
                            }
                        // Text by default
                        default :
                            var elem: Element = cast selected[0];
                            elem.contentEditable = Std.string(editable);
                            if (editable) {
                                // Activate CKEditor inline edition
                                editorInstances.push(untyped __js__("CKEDITOR.inline(elem)"));
                            }
                    }
                }
            });
        } else {
            tools.state = FILE_SELECTED;
            for (inst in editorInstances) {
                inst.destroy();
            }
            // reset array, calling destroy on a previous destroyed instance throw an error
            editorInstances = new Array<Editor>();
            var nodes = stageWindow.document.querySelectorAll('[contenteditable]');
            for(node in nodes){
              if(Std.is(node, DOMElement)){
                cast(node, DOMElement).removeAttribute('contenteditable');
              }
            }
        }

        stageWindow.document.body.classList.toggle("edition-on");
        duplicable(!editable);
    }

    private function initFieldEditable(): Void {
    }

    private function onFileSelected(blob: CEBlob): Void {
        fileSelected = blob;
        // set Stage url from Cloud Explorer blob
        stage.setUrl(fileSelected.url).then(function(doc) {
            wysiwyg.setDocument(doc);
            // Store iframe window
            stageWindow = doc.defaultView;
            wysiwyg.addTempStyle("/editor.css");
            duplicable(true);
            return doc;
        });
        tools.state = State.FILE_SELECTED;
    }

    private function duplicable (active: Bool): Void {
        if (active) {
            var allRepeatable = stageWindow.document.querySelectorAll("[data-bn-repeatable]");
            for (repeatable in allRepeatable) {
                makeDuplicable (cast repeatable);
            }
        } else {
            var allAdd = stageWindow.document.querySelectorAll(".addBtn");
            var allRemove = stageWindow.document.querySelectorAll(".removeBtn");
            for (btn in allAdd) {
                stageWindow.document.body.removeChild(btn);
            }
            for (btn in allRemove) {
                stageWindow.document.body.removeChild(btn);
            }
        }
    }

    private function makeDuplicable (elem : Element, ?addRemove: Bool) {
        var elemPlus : DivElement = stageWindow.document.createDivElement();
        elemPlus.classList.add("addBtn");
        elemPlus.style.top = elem.offsetTop + "px";
        elemPlus.style.left = (elem.offsetLeft - (addRemove ? 50 : 25)) + "px";
        stageWindow.document.body.appendChild(elemPlus);

        elemPlus.onclick = function(e:Event) {
            e.preventDefault();
            var clone : Element = cast elem.cloneNode(true);
            elem.parentElement.insertBefore(clone, elem.nextSibling);
            makeDuplicable(clone, true);
        };

        if (addRemove) {
            var elemMoins : DivElement = stageWindow.document.createDivElement();
            elemMoins.classList.add("removeBtn");
            elemMoins.style.top = elem.offsetTop + "px";
            elemMoins.style.left = (elem.offsetLeft - 25) + "px";
            stageWindow.document.body.appendChild(elemMoins);

            elemMoins.onclick = function(e: Event){
                e.preventDefault();
                stageWindow.document.body.removeChild(elemMoins);
                stageWindow.document.body.removeChild(elemPlus);
                elem.parentElement.removeChild(elem);
            };
        }
    }


    private function onError(e: Dynamic): Void {
        try {
            trace("Error: " + Json.stringify(e));
        } catch (e: Dynamic) {
            trace("Error undefined");
        }
    }
}
