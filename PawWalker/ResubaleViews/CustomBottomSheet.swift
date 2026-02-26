//
//
//  CustomBottomSheet.swift
//  Flashat
//
//  Created by Nikhil Raj on 19/12/22
//  Copyright © 2022 messej. All rights reserved.
//


import SwiftUI

private struct Distances {
    static let hidden: CGFloat = 500
    static let maxUp: CGFloat = -100
    static let dismiss: CGFloat = 100
}

struct BottomSheet<Content: View>: View {
    @Binding var isPresented: Bool
    @Binding var isDraggEnabled: Bool
    var isShowOutSideTap: Bool
    var withPadding: Bool
    @ViewBuilder let content: Content
    var backgroundColor : Color
    var outSideColor: Color
    @State private var translation = Distances.hidden
    var outSideTapAction: () -> ()?
    var body: some View {
        ZStack {
            outSideColor
                .onTapGesture {
                    if isShowOutSideTap {
                        isPresented = false
                        outSideTapAction()
                    }
                }
            VStack {
                Spacer()
                contentView
                    .offset(y: translation)
                    .animation(.interactiveSpring(), value: isPresented)
                    .animation(.interactiveSpring(), value: translation)
                    .if(self.isDraggEnabled, transform: { v in
                        v.gesture(
                            DragGesture()
                                .onChanged { value in
                                    guard translation > Distances.maxUp else { return }
                                    translation = value.translation.height
                                }
                                .onEnded { value in
                                    if value.translation.height > Distances.dismiss {
                                        translation = Distances.hidden
                                        isPresented = false
                                    } else {
                                        translation = 0
                                    }
                                }
                        )
                        
                    })
            }
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation {
                translation = 0
            }
        }
    }
    
    private var contentView: some View {
        VStack(spacing: 0) {
            handle
                .padding(.top, 6)
                .isRemove(!isDraggEnabled || !self.withPadding)
            content
                .padding(self.withPadding ? 10 : 0)
        }
        .frame(maxWidth: .infinity)
        .background(backgroundColor)
        .cornerRadius(20)
        .shadow(color: ColorContants.dropShadow, radius: 2, x: 0, y: -2)
    }
    
    private var handle: some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(Color.gray)
            .frame(width: 50, height: 5)
    }
}

extension View {
    func bottomSheet<Content: View>(
        isPresented: Binding<Bool>,
        isDraggEnabled: Binding<Bool> = .constant(false),
        isShowOutSideTap: Bool = true,
        backgroundColor: Color? = nil,
        outSideColor: Color = ColorContants.bluredBGColor,
        withPadding: Bool = true,
        showBackgroundImage: Bool = false,
        outSideTapAction: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        let effectiveBackgroundColor = backgroundColor ?? self.backgroundColor()

        return self
            .overlay(
                Group {
                    if isPresented.wrappedValue {
                        BottomSheet(
                            isPresented: isPresented,
                            isDraggEnabled: isDraggEnabled,
                            isShowOutSideTap: isShowOutSideTap,
                            withPadding: withPadding,
                            content: content,
                            backgroundColor: effectiveBackgroundColor,
                            outSideColor: outSideColor,
                            outSideTapAction: outSideTapAction ?? {}
                        )
                    }
                }
            )
    }

    func backgroundColor() -> Color {
       .white
    }
}
