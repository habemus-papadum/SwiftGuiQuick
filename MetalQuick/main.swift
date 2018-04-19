import Cocoa
import Metal
import QuartzCore

//Throw away metal app

print("Hello, Triangle!")

// Accessing this property causes some side effect that is needed to initialize the Application Framework
_ = NSApplication.shared


//main logic

//globals
var mainWindow: NSWindow! //needed to retain window to avoid collection
var render: (()->())!  //ditto
func displayLinkCallback(displayLink: CVDisplayLink,
                               _ inNow: UnsafePointer<CVTimeStamp>,
                               _ inOutputTime: UnsafePointer<CVTimeStamp>,
                               _ flagsIn: CVOptionFlags,
                               _ flagsOut: UnsafeMutablePointer<CVOptionFlags>,
                               _ displayLinkContext: UnsafeMutableRawPointer?) -> CVReturn {
    render();
    return kCVReturnSuccess
}

func appMain() {


    let device = MTLCreateSystemDefaultDevice()!
    let metalLayer = CAMetalLayer()
    metalLayer.device = device

    metalLayer.autoresizingMask = [.layerHeightSizable, .layerWidthSizable]
    metalLayer.pixelFormat = .bgra8Unorm
    metalLayer.framebufferOnly = true

    let vertexData:[Float] = [
        0.0, 0.5, 0.0,
        -1.0, -0.5, 0.0,
        1.0, -0.5, 0.0
    ]
    // Set the Vertex Buffer
    let dataSize = vertexData.count * MemoryLayout.size(ofValue: vertexData[0])
    let vertexBuffer = device.makeBuffer(bytes: vertexData, length: dataSize, options: [])!

    let library = try! device.makeLibrary(source: """
    #include <metal_stdlib>
    using namespace metal;
    
    vertex float4 basic_vertex(const device packed_float3* vertex_array [[ buffer(0) ]], unsigned int vid [[ vertex_id ]]) {
        return float4(vertex_array[vid], 1.0);
    }
    
    fragment half4 basic_fragment(){
        return half4(1.0);
    }
    """, options: MTLCompileOptions())

    let fragmentProgram = library.makeFunction(name: "basic_fragment")
    let vertexProgram = library.makeFunction(name: "basic_vertex")

    let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
    pipelineStateDescriptor.vertexFunction = vertexProgram
    pipelineStateDescriptor.fragmentFunction = fragmentProgram
    pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
    let metalPipeline = try! device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
    let commandQueue = device.makeCommandQueue()!
    var displayLink: CVDisplayLink?

    render = {
        let renderPassDescriptor = MTLRenderPassDescriptor()
        let drawable = metalLayer.nextDrawable()
        renderPassDescriptor.colorAttachments[0].texture = drawable!.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 1.0, green: 0.0, blue: 1.0, alpha: 1.0)

        // Create Command Buffer
        let commandBuffer = commandQueue.makeCommandBuffer()

        // Create Render Command Encoder
        let renderEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        renderEncoder?.setRenderPipelineState(metalPipeline)
        renderEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3, instanceCount: 1)
        renderEncoder?.endEncoding()

        // Commit the Command Buffer
        commandBuffer?.present(drawable!)
        commandBuffer?.commit()
    }

    CVDisplayLinkCreateWithActiveCGDisplays(&displayLink)
    CVDisplayLinkSetOutputCallback(displayLink!, displayLinkCallback, nil)
    CVDisplayLinkStart(displayLink!)


    let view = NSView(frame: NSMakeRect(0, 0, 320, 200))
    view.layer = metalLayer;
    view.wantsLayer = true

    mainWindow = NSWindow(contentRect: NSMakeRect(800, 600, 320, 200),
            styleMask: [.titled, .closable, .resizable],
            backing: .buffered,
            defer: true)

    mainWindow.contentView!.addSubview(view);
    mainWindow.orderFrontRegardless()
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





