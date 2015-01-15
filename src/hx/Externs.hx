import js.html.Element;
import js.html.Document;

@:native('Promise')
extern class Promise<T> {
    public function new(): Void;
    public function then(cbk: T -> Void): Promise<T>;
    /*
    // FIXME: this method is supposed to be called catch
    public function catch(cbk: js.Error -> Void): Promise<T>;
    */
}


typedef Blob = {
    url: String
}

typedef CEBlob = {
    url: String,
    filename: String,
    mimetype: String,
    size: Int
}

@:native('Stage')
extern class Stage {
    public function new(element: Element): Void;
    public function setUrl(url: String): Promise<Document>;
    public function setSize(w: Int, h: Int): Void;
}


@:native('Wysiwyg')
extern class Wysiwyg {
    public function new(): Void;
    public function setSelectionMode(enableSelection: Bool): Void;
    public function setDocument(doc: Document): Void;
    public function getSelected(): Array<Element>;
    public function setBeforeSelect(onBeforeSelect: Element -> Bool): Void;
    public function getBeforeSelect(): Element -> Bool;
    public function setOnSelect(onSelect: Void -> Void): Void;
    public function getOnSelect(): Void -> Void;
    public function addTempStyle(url: String):Void;
    public function addTempScript(url: String):Void;
}

@:native('ce.api.CloudExplorer')
extern class CloudExplorer {
    static function get(?id: String): CloudExplorer;
    public function pick(cbk: CEBlob -> Void, err: Dynamic -> Void): Void;
    public function exportFile(blob: CEBlob, options: {mimetype: String}, cbk: CEBlob -> Void): Void;
    public function write(blob: CEBlob, data: String, cbk: CEBlob -> Void, cbkError: Dynamic -> Void): Void;
}


@:native('FileService')
extern class FileService {
    public function new(): Void;
    public function open(): Promise<Blob>;
}

@:native('CKEDITOR')
extern class CKEditor{
    public static var disableAutoInline:Bool;
    public static var currentInstance: Editor;

    // Doesn't work. Waiting for https://github.com/HaxeFoundation/haxe/issues/3701
    @:native("inline")
    public static function inlineEdition(element: Element):Editor;
}

@:native('CKEDITOR.editor')
extern class Editor{
    function destroy(): Void;
}
