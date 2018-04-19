
import Cocoa

print("Hello, world!")

// Accessing this property causes some side effect that is needed to initialize the Application Framework
// Without it, you get a core dump due to access violation.
// should be wrapped into a more user friendly function e.g. initCocoa()
_ = NSApplication.shared

////#1 status bar --- TODO -- no longer seems to work
//let statusItem = NSStatusBar.system.statusItem(withLength: 20)
//statusItem.title = "Quit"
//statusItem.action = #selector(NSApplication.terminate)




//#2 standalone window, without using app delegate (not the typical pattern)
//but the most lean and mean
//let window = NSWindow(contentRect: NSMakeRect(0, 0, 320, 200),
//        styleMask: .titled,
//        backing: .buffered,
//        defer: true)
//window.orderFrontRegardless()
//NSApp.run()


//#3 Custom app delegate (closer to typical pattern)
//(typical pattern subclasses AppDelegate to allow to customize all hooks)

//main logic
var mainWindow: NSWindow? //need to retain window to avoid collection
func appMain() {
    let window = NSWindow(contentRect: NSMakeRect(800, 600, 320, 200),
            styleMask: [.titled, .closable, .resizable],
            backing: .buffered,
            defer: true)

    let view = NSView(frame: NSMakeRect(0, 0, 320, 200))
    let layer = CALayer.init();

    layer.backgroundColor = NSColor.red.cgColor;
    layer.autoresizingMask = [.layerHeightSizable, .layerWidthSizable]
    view.layer = layer;
    view.wantsLayer = true


    window.contentView!.addSubview(view);
    window.orderFrontRegardless()
    mainWindow = window
    NSApp.activate(ignoringOtherApps: true)
}

//// Plumbing
class AppDel: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        appMain()
    }
    //if you like
    func applicationShouldTerminateAfterLastWindowClosed(_ app: NSApplication) -> Bool {
        return true
    }
}
NSApp.setActivationPolicy(.regular)
NSApp.delegate = AppDel()
NSApp.run()




