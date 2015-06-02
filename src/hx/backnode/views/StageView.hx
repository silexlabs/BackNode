package backnode.views;

import js.html.Element;
import js.html.Event;
import js.html.NodeList;
import js.html.Node;
import js.Browser;

class StageView {

    private var stage: Element;
    private var resolution: Element;
    private var presets: Element;
    private var cbkSizeChange: {w: Int, h: Int} -> Void;

    public function new(): Void {
        stage = getStage();
        resolution = getResolution();
        presets = getPresets();

        setCurrentResolution();

        Browser.window.onresize = onWindowResize;
    }

    public function onSizeChange(cbk: {w: Int, h: Int} -> Void): Void {
        cbkSizeChange = cbk;
    }

    private function getStage(): Element {
        var s: Element = Browser.document.getElementById('stage');
        return cast s.getElementsByTagName('iframe')[0];
    }

    private function getResolution(): Element {
        var r: Element = Browser.document.getElementById('resolution-current');
        r.parentElement.addEventListener('click', switchPresets, true);

        var presetButtons = r.parentElement.getElementsByTagName('li');
        for (b in Reflect.fields(presetButtons)) {
            var f: Node = cast Reflect.field(presetButtons, b);
            if (f.addEventListener != null) {
                f.addEventListener('click', clickOnPreset);
            }
        }
        return r;
    }

    private function getPresets(): Element {
        var r: Element = Browser.document.getElementById('resolution-presets');
        r.style.display = 'none';
        return r;
    }

    private function setCurrentResolution(?w: Int, ?h: Int): Void {
        var width: Int = w != null ? w : stage.offsetWidth;
        var height: Int = h != null ? h : stage.offsetHeight;
        resolution.innerHTML = width + 'x' + height;

        if (cbkSizeChange != null) {
            cbkSizeChange({w: width, h: height});
        }
    }

    private function onWindowResize(?e: Event): Void {
        setCurrentResolution();
    }

    private function switchPresets(?e: Event): Void {
        presets.style.display = presets.style.display == 'block' ? 'none' : 'block';
    }

    private function clickOnPreset(e: Event): Void {
        var preset: Element = cast e.currentTarget;
        var auto: Bool = preset.innerHTML == 'Full size';
        var width: Int = auto ?
            stage.parentElement.offsetWidth :
            Std.parseInt(preset.getAttribute('data-width'));
        var height: Int = auto ?
            stage.parentElement.offsetHeight :
            Std.parseInt(preset.getAttribute('data-height'));

        setCurrentResolution(width, height);
    }
}
