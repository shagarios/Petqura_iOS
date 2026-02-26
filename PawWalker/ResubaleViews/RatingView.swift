//
//  RatingView.swift
//  PawWalker
//
//  Created by shagar on 13/05/25.
//
import SwiftUI
import StarRateView

struct RatingView : View {
     var starCount: Int = 5
     var rate: Double
     var starSize: CGFloat = 15
     var starPadding: CGFloat = 4
     var foregroundColor: Color = .yellow
     var backgroundColor: Color = .gray
     var body: some View {
           StarRateView(starCount: starCount, rate: rate)
               .starSize(starSize)
               .starPadding(starPadding)
               .forgroundStarColor(foregroundColor)
               .backgroundStarColor(backgroundColor)
       }
}
