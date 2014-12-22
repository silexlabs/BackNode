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

    public function new(): Void {
        stage = getStage();
        resolution = getResolution();
        presets = getPresets();

        setCurrentResolution();

        Browser.window.onresize = onWindowResize;
    }

    private function getStage(): Element {
        return Browser.document.getElementById('stage');
    }

    private function getResolution(): Element {
        var r: Element = Browser.document.getElementById('resolution-current');
        r.parentElement.addEventListener('click', switchPresets, true);

        var presetButtons: NodeList = r.parentElement.getElementsByTagName('li');
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
    }

    private function onWindowResize(?e: Event): Void {
        setCurrentResolution();
    }

    private function switchPresets(?e: Event): Void {
        presets.style.display = presets.style.display == 'block' ? 'none' : 'block';
    }

    private function clickOnPreset(e: Event): Void {
        var preset: Element = cast e.currentTarget;
        var width: Int = Std.parseInt(preset.getAttribute('data-width'));
        var height: Int = Std.parseInt(preset.getAttribute('data-height'));
        var auto: Bool = preset.innerText == 'Auto';

        stage.parentElement.style.width = auto ? '' : width + 'px';
        stage.parentElement.style.height = auto ? '' : (height + 45) + 'px'; // 45 because parent have 45px more than stage

        centerStageContainer(stage.parentElement, width, height, auto ? true : false);
        setCurrentResolution(width, height);
    }

    private function centerStageContainer(element: Element, width: Int, height: Int, ?reset: Bool): Void {
        element.className = reset ? 'auto-fit' : '';
        element.style.left = element.style.top = reset ? '' : '50%';
        element.style.marginLeft = reset ? '' : '-' + (width / 2) + 'px';
        element.style.marginTop = reset ? '' : '-' + (height / 2) + 'px';

        if (height > Browser.window.innerHeight) {
            element.style.top = element.style.marginTop = "0";
        }
    }
}
