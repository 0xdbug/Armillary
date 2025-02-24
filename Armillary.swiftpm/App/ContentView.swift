import SwiftUI

protocol Page: View {
    var nextAction: () -> Void { get }
    var supportedOrientations: UIInterfaceOrientationMask { get }
}

extension Page {
    var supportedOrientations: UIInterfaceOrientationMask {
        return [.landscape, .landscapeLeft, .landscapeRight]
    }
}

struct ContentView: View {
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            GridView()
                .ignoresSafeArea()
            
            GeometryReader { geometry in
                ZStack {
                    switch currentPage {
                        case 0:
                            Intro(nextAction: { currentPage = 1 })
                                .transition(.blurReplace)
                        case 1:
                            EpicyclePage(nextAction: { currentPage = 2 })
                                .transition(.blurReplace)
                        case 2:
                            TaskPage(nextAction: { currentPage = 3 })
                                .transition(.blurReplace)
                        case 3:
                            ThirdPage(nextAction: { currentPage = 4 })
                                .transition(.blurReplace)
                        case 4:
                            ForthPage(nextAction: { currentPage = 5 })
                                .transition(.blurReplace)
                        case 5:
                            FifthPage(nextAction: { currentPage = 6 })
                                .transition(.blurReplace)
                        case 6:
                            SixthPage(nextAction: { currentPage = 7 })
                                .transition(.blurReplace)
                        default:
                            Text("End of playground")
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
            .ignoresSafeArea()
        }
        .animation(.smooth(duration: 0.4), value: currentPage)
    }
}
