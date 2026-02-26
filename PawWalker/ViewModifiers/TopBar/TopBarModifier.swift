//
//  TopBarModifier.swift
//  PawWalker
//
//  Created by shagar on 08/12/24.
//

import SwiftUI
import SwiftUIIntrospect

struct TopBarModifier<TopBarContents : View> : ViewModifier {
    var leftBarButtons : TopBarContents
    var titleView : TopBarContents
    var rightBarButtons : TopBarContents
    init(leftBarButtons: TopBarContents, titleView: TopBarContents, rightBarButtons: TopBarContents) {
        self.leftBarButtons = leftBarButtons
        self.titleView = titleView
        self.rightBarButtons = rightBarButtons
    }
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

        var isIPad: Bool {
            horizontalSizeClass == .regular
        }
    func body(content: Content) -> some View {
        VStack(spacing : 0) {
            ZStack{
                HStack(spacing: 0) {
                    leftBarButtons
                    Spacer()
                    rightBarButtons
                        .padding(.trailing,10)
                }
                titleView
            }
            .onTapGestureForced {
                UIApplication.shared.endEditing()
            }
            .padding(.top, isIPad ? 100 : 50)
            .padding(.bottom,5)
            .padding(.horizontal,10)
            .frame(maxWidth : .infinity)
            .background(
                Rectangle()
                    .fill(
                        Color.headerBgGradient
                    )
            )
            content
        }
        .hideNavigationBar()
        .edgesIgnoringSafeArea(.top)
    }
}
extension View {
    func topBarView(titleView : any View,
                    leftButtons : any View = EmptyView(),
                    rightButtons : any View = EmptyView()) -> some View {
        modifier(
            TopBarModifier(leftBarButtons: AnyView(leftButtons),
                           titleView: AnyView(titleView),
                           rightBarButtons: AnyView(rightButtons))
        )
        
    }
    
    
    func hideNavigationBar() -> some View {
        modifier(navigationBarHiddenModifier())
    }
    @MainActor func forcefullyHideNavigationBar() -> some View {
        self.introspect(.navigationView(style: .stack), on: .iOS(.v14, .v15, .v16, .v17, .v18)) { (navigator) in
            navigator.navigationBar.isHidden = true
            navigator.isNavigationBarHidden = true
            NavigationControllerDelegate.shared.becomeDelegate(of: navigator)
            navigator.interactivePopGestureRecognizer?.isEnabled = false
        }
    }
}

class NavigationControllerDelegate: NSObject {
    static let shared = NavigationControllerDelegate()
    func becomeDelegate(of navigationController: UINavigationController) {
        navigationController.isNavigationBarHidden = true
        navigationController.navigationBar.isHidden = true
        navigationController.navigationBar.addObserver(self, forKeyPath: ObserverName.alpha, options: .new, context: nil)
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        //MARK: This is necessary to ensure the UINavigationBar remains hidden
        if let navigationBar = object as? UINavigationBar {
            navigationBar.isHidden = true
        }
    }
}
struct navigationBarHiddenModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .navigationBarTitle("", displayMode: .inline)
            .navigationTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .edgesIgnoringSafeArea([.top, .bottom])
            .introspect(.navigationView(style: .stack), on: .iOS(.v14, .v15, .v16, .v17, .v18)) { (UINavigationController) in
                NavigationControllerDelegate.shared.becomeDelegate(of: UINavigationController)
                UINavigationController.interactivePopGestureRecognizer?.isEnabled = false
            }
    }
}
