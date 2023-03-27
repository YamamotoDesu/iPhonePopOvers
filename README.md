# iPhonePopOvers
https://www.youtube.com/watch?v=5VPEcZy0FaQ&t=1s

<img width="300" alt="スクリーンショット 2023-03-28 7 54 11" src="https://user-images.githubusercontent.com/47273077/228085003-06ba050c-e9f6-463e-a278-a40732c52d82.gif">

## Set up Popover

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

## [Detect alrearyPresented](https://github.com/YamamotoDesu/iPhonePopOvers/commit/775fed357f716af4fff78808c10c9d3bf89ac11c)
![2023-03-28 07 18 46](https://user-images.githubusercontent.com/47273077/228079571-8884bd36-5242-4933-91d3-02a9f1b54513.gif)

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

## [Closing Popover](https://github.com/YamamotoDesu/iPhonePopOvers/commit/ec9eda3fcd1e176eefc2122d6a4169a1ec3073f3)

<img width="300" alt="スクリーンショット 2023-03-28 7 23 38" src="https://user-images.githubusercontent.com/47273077/228080471-ffda40f3-6248-4576-aeaa-bd54cc72165a.gif">

iOSPopover.swift
```swift
  func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
        if alrearyPresented {
            /// - Close View, if it's toggled back
            if !isPresented {
                /// - Closing Popover
                uiViewController.dismiss(animated: true) {
                    // - Rsetting alredyPresented State
                    alrearyPresented = false
                }
            }
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
```

## [Updating SwiftUI View, when it's Changed](https://github.com/YamamotoDesu/iPhonePopOvers/commit/a230abc2339883c28ed838d144e6044259658c21)

<img width="300" alt="スクリーンショット 2023-03-28 7 23 38" src="https://user-images.githubusercontent.com/47273077/228081925-62dde573-e0df-4b28-aa0c-cb635fb9dbbb.gif">

iOSPopover.swift
```swift
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
        if alrearyPresented {
            /// - Updating SwiftUI View, when it's Changed
            if let hostingController = uiViewController.presentedViewController as? CustomHostingView<Content> {
                hostingController.rootView = content
            }
            
            /// - Close View, if it's toggled back
            if !isPresented {
                /// - Closing Popover
                uiViewController.dismiss(animated: true) {
                    // - Rsetting alredyPresented State
                    alrearyPresented = false
                }
            }
        } else {
```

## [Updating SwiftUI View, when it's Changed](https://github.com/YamamotoDesu/iPhonePopOvers/commit/ea9fccb9d619e0782bab4690e1d4d805f3365a98)

<img width="300" alt="スクリーンショット 2023-03-28 7 23 38" src="https://user-images.githubusercontent.com/47273077/228083385-be1b4ae3-6d91-4ca3-8a85-6416f2b5109c.gif">

iOSPopover.swift
```swift
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
        if alrearyPresented {
            /// - Updating SwiftUI View, when it's Changed
            if let hostingController = uiViewController.presentedViewController as? CustomHostingView<Content> {
                hostingController.rootView = content
                /// - Updating View Size when it's Updated
                /// - 0r you can define your own size in SwiftUI  View
                hostingController.preferredContentSize = hostingController.view.intrinsicContentSize
            }
            
            /// - Close View, if it's toggled back
            if !isPresented {
                /// - Closing Popover
                uiViewController.dismiss(animated: true) {
                    // - Rsetting alredyPresented State
                    alrearyPresented = false
                }
            }
        } else {
 ```
 
## [Set Frame Width](https://github.com/YamamotoDesu/iPhonePopOvers/commit/67e349e825b9b9df6e2eeeebd33efaa86b3d8978)
<img width="300" alt="スクリーンショット 2023-03-28 7 23 38" src="https://user-images.githubusercontent.com/47273077/228084033-822eedaf-444c-40b3-87f7-40a53c9417f6.gif">

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
            .frame(width: 250)
```

## [Give Full Popover Color](https://github.com/YamamotoDesu/iPhonePopOvers/commit/3dc2641eb7f6d2e819841cb72e88e5ca3b87ed49)

<img width="300" alt="スクリーンショット 2023-03-28 7 54 11" src="https://user-images.githubusercontent.com/47273077/228084805-f8bf7dc1-5060-4a59-9045-559988d08b70.png">

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
            .foregroundColor(.white)
            .padding(15)
            /// - You can also Give Full Popover Color like this
            .background {
                Rectangle()
                    .fill(.blue.gradient)
                    .padding(-20)
            }
        }
 ```

