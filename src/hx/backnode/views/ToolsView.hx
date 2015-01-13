package backnode.views;

import js.html.Element;
import js.html.Event;
import js.Browser;

import backnode.model.State;

typedef Buttons = {
    open: ButtonTool,
    save: ButtonTool,
    cancel: ButtonTool,
    edition: ButtonTool,
    editionSwitch: ButtonTool
}

typedef ButtonTool = {
    dom: Element,
    hide: Void-> Void,
    show: Void -> Void
}

class ToolsView {

    public var state(default, set): State;
    public var currentState: State;
    public var buttons: Buttons = {
        open: null,
        save: null,
        cancel: null,
        edition: null,
        editionSwitch: null
    };

    public function new() {
        initButtons();
    }

    public function onOpen(cbk: Event -> Void): Void {
        buttons.open.dom.addEventListener('click', cbk , false);
    }

    public function onCancel(cbk: Event -> Void): Void {
        buttons.cancel.dom.addEventListener('click', cbk , false);
    }

    public function onStartEdition(cbk: Bool -> Void): Void {
        buttons.editionSwitch.dom.addEventListener('click', function (e) {
            cbk(buttons.editionSwitch.dom.classList.toggle("switch-on"));
        } , false);
    }

    public function set_state(state: State): State {
        currentState = state;
        onStateChanged(currentState);
        return currentState;
    }

    private function initButtons(): Void {
        initButton('open');
        initButton('save');
        initButton('cancel');
        initButton('edition', 'edit-mode');
        initButton('editionSwitch', 'editor-switch');
    }

    private function initButton(name: String, ?id: String): Void {
        var button: ButtonTool = {
            dom: Browser.document.getElementById(id != null ? id : name),
            hide: function(): Void {
                var b: ButtonTool = cast Reflect.getProperty(buttons, name);
                b.dom.style.display = 'none';
            },
            show: function(): Void {
                var b: ButtonTool = cast Reflect.getProperty(buttons, name);
                b.dom.style.display = 'block';
            }
        }
        Reflect.setField(buttons, name, button);
    }

    private function onStateChanged(state: State): Void {
        switch(state) {
            case State.INIT:
                switchEditionMode(false);
            case State.FILE_SELECTED:
                switchEditionMode(true);
        }
    }

    private function switchEditionMode(value: Bool): Void {
        for (button in Reflect.fields(buttons)) {
            if (value) {
                Reflect.field(buttons, button).show();
            } else {
                Reflect.field(buttons, button).hide();
            }
        }
        buttons.open.show();
    }
}
