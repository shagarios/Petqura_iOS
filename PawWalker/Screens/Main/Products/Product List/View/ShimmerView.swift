//
//  ShimmerView.swift
//  PawWalker
//
//  Created by shagar on 16/08/26.
//

import SwiftUI

struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = -1

    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geo in
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0),
                            Color.white.opacity(0.6),
                            Color.white.opacity(0)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geo.size.width * 1.5)
                    .offset(x: phase * geo.size.width * 2 - geo.size.width * 0.5)
                }
            )
            .mask(content)
            .onAppear {
                withAnimation(
                    Animation.linear(duration: 1.2)
                        .repeatForever(autoreverses: false)
                ) {
                    phase = 1
                }
            }
    }
}

extension View {
    func shimmering() -> some View {
        self.modifier(ShimmerModifier())
    }
}
struct SkeletonBlock: View {
    var width: CGFloat? = nil
    var height: CGFloat
    var cornerRadius: CGFloat = 6

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color.gray.opacity(0.25))
            .frame(width: width, height: height)
    }
}

struct ProductItemSkeletonView: View {
    var body: some View {
        VStack(spacing: 0) {
            // image
            SkeletonBlock(width: 130, height: 130, cornerRadius: 20)

            // name (2 lines)
            VStack(alignment: .leading, spacing: 6) {
                SkeletonBlock(width: 150, height: 12)
                SkeletonBlock(width: 100, height: 12)
            }
            .padding(.top, 10)

            // variants row
            HStack(spacing: 8) {
                SkeletonBlock(width: 44, height: 28, cornerRadius: 8)
                SkeletonBlock(width: 44, height: 28, cornerRadius: 8)
                SkeletonBlock(width: 44, height: 28, cornerRadius: 8)
            }
            .padding(.top, 5)

            // price row
            HStack(spacing: 6) {
                SkeletonBlock(width: 40, height: 12)
                SkeletonBlock(width: 40, height: 12)
                Spacer()
            }
            .frame(width: 150)
            .padding(.top, 5)

            // cart button
            SkeletonBlock(height: 33, cornerRadius: 15)
                .padding(.top, 5)
        }
        .shimmering()
    }
}
struct ProductListSkeletonView: View {
    let columns: [GridItem]
    let itemCount: Int = 6

    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(0..<itemCount, id: \.self) { _ in
                    ProductItemSkeletonView()
                }
            }
        }
    }
}
