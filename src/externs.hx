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
  public function setContainer(element: Element): Void;
  public function getSelected(): Array<Element>;
  public function setBeforeSelect(onBeforeSelect: Element -> Bool): Void;
  public function getBeforeSelect(): Element -> Bool;
  public function setOnSelect(onSelect: Void -> Void): Void;
  public function getOnSelect(): Void -> Void;
}


@:native('FileService')
extern class FileService {
  public function new(): Void;
  public function open(): Promise<Blob>;
}




