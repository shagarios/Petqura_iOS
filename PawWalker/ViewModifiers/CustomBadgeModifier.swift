//
//  CustomBadgeModifier.swift
//  PawWalker
//
//  Created by shagar on 12/02/25.
//

import SwiftUI

struct CustomBadgeModifier : ViewModifier {
    let count : Int
    let maxCount : Int
    
    func body(content: Content) -> some View {
        if count > 0 {
                    content
                    .overlay(
                        countView
                            .padding(.leading,5)
                            .padding(.top,-5)
                        ,alignment: .topTrailing)
        }
        else {
            // if the count is less than or equal to zero, we don't want to add a badge
            content
        }
 
    }
    var countView : some View {
       HStack(spacing: 0) {
           // min returns the smallest value of either count, or the maxCountAmount
           Text(min(count, maxCount),format: .number)
           // optionally adding a plus sign if our badge count gets too large to let the user know
           // there are more badges than we want to display
           if count > maxCount {
               Text("+")
           }
       }
       .font(FontConstants.primaryRegularTitle12)
       .foregroundStyle(.white)
       .padding(.horizontal,5)
       // when the badge is a single digit, I like the badge to be close to a circle shape
       .padding(.vertical,count > 9 ? 7 : 5)
       .background(Color.red)
       // when the badge is more than one digit, I like the badge to look like a capsule
       .frame(height : count > 9 ? 17 : 19)
       .clipShape(Capsule())
   }
}

extension View {
    func customBadge(count : Int = 0, maxCount : Int = 99) -> some View {
        modifier(CustomBadgeModifier(count: count, maxCount: maxCount))
    }
}
