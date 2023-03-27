# iPhonePopOvers

<img width="300" alt="スクリーンショット 2023-03-28 6 44 20" src="https://user-images.githubusercontent.com/47273077/228073988-304b5f1d-cb05-4222-b585-e1c63cecc6e9.gif">


iOSPopover.swift
```swift
import SwiftUI

// - Enabling Popover for iOS
extension View {
    @ViewBuilder
    func iOSPopover<Content: View>(isPresented: Binding<Bool>,arrowDirection: UIPopoverArrowDirection,@ViewBuilder content: @escaping ()->Content)->some View{
        self
            .background {
                PopOverController(isPresented: isPresented, arrowDirection: arrowDirection, content: content())
            }
    }
}


/// - Popover Helper
fileprivate struct PopOverController<Content: View>: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    var arrowDirection: UIPopoverArrowDirection
    var content: Content
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        controller.view.backgroundColor = .clear
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if isPresented {
            /// - Presenting Popover
//            let controller = UIHostingController(rootView: content)
            let controller = CustomHostingView(rootView: content)
            controller.view.backgroundColor = .clear
            controller.modalPresentationStyle = .popover
            controller.popoverPresentationController?.permittedArrowDirections = arrowDirection
            
            /// - Connecting Delegate
            controller.presentationController?.delegate = context.coordinator
            
            /// - We head to Attach the Source View So that it will show Arrow At Correct Position
            controller.popoverPresentationController?.sourceView = uiViewController.view
            /// - Simply Presenting PopOver Controller
            uiViewController.present(controller, animated: true)
        }
    }
    
    /// - Forcing it  to show Popover using PresentationDelegate
    class Coordinator: NSObject, UIPopoverPresentationControllerDelegate {
        var parent: PopOverController
        init(parent: PopOverController) {
            self.parent = parent
        }
        
        func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
            return .none
        }
        
        /// - Observing the status of the Popover
        /// - When it is dismissed updating the isPresented State
        func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
            parent.isPresented = false
        }
    }
}

/// - Custom Hosting Controller for Wrapping to it's SwiftUI View Size
fileprivate class CustomHostingView<Content: View>: UIHostingController<Content>{
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize = view.intrinsicContentSize
    }
}

```

Home.swift
```swift
import SwiftUI

struct Home: View {
    /// - View Properties
    @State private var showPopover: Bool = false
    var body: some View {
        Button("Show Popover") {
            showPopover.toggle()
        }
        .iOSPopover(isPresented: $showPopover, arrowDirection: .up) {
            Text("Hello, it is me, Popover.")
                .padding(15)
        }
//        .popover(isPresented: $showPopover) {
//            Text("Hello. It is Kyo.")
//        }
    }
}
```

## Detect alrearyPresented
iOSPopover.swift
```swift
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
        if alrearyPresented {
            /// - Close View, if it's toggled back
            print(isPresented)
        } else {
            if isPresented {
                /// - Presenting Popover
    //            let controller = UIHostingController(rootView: content)
                let controller = CustomHostingView(rootView: content)
                controller.view.backgroundColor = .clear
                controller.modalPresentationStyle = .popover
                controller.popoverPresentationController?.permittedArrowDirections = arrowDirection
                
                /// - Connecting Delegate
                controller.presentationController?.delegate = context.coordinator
                
                /// - We head to Attach the Source View So that it will show Arrow At Correct Position
                controller.popoverPresentationController?.sourceView = uiViewController.view
                /// - Simply Presenting PopOver Controller
                uiViewController.present(controller, animated: true)
            }
        }
    }
    
    /// - Forcing it  to show Popover using PresentationDelegate
    class Coordinator: NSObject, UIPopoverPresentationControllerDelegate {
        var parent: PopOverController
        init(parent: PopOverController) {
            self.parent = parent
        }
        
        func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
            return .none
        }
        
        /// - Observing the status of the Popover
        /// - When it is dismissed updating the isPresented State
        func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
            parent.isPresented = false
        }

        /// - When the popover is presented, updating the alredyPresented State
        func presentationController(
            _ presentationController: UIPresentationController,
            willPresentWithAdaptiveStyle style: UIModalPresentationStyle,
            transitionCoordinator: UIViewControllerTransitionCoordinator?
        ) {
            
            DispatchQueue.main.async {
                self.parent.alrearyPresented = true
            }
        }
    }
```

Home.swift
```swift
struct Home: View {
    /// - View Properties
    @State private var showPopover: Bool = false
    @State private var updateText: Bool = false
    var body: some View {
        Button("Show Popover") {
            showPopover.toggle()
        }
        .iOSPopover(isPresented: $showPopover, arrowDirection: .down) {
            VStack(spacing: 12) {
                Text("Hello, it is me. \(updateText ? "Updated Popover" : "Popover").")
                    .padding(15)
                Button("Update Text") {
                    updateText.toggle()
                }
                Button("Close Text") {
                    showPopover.toggle()
                }
            }
            .padding(15)
        }
//        .popover(isPresented: $showPopover) {
//            Text("Hello. It is Kyo.")
//        }
    }
}
```
