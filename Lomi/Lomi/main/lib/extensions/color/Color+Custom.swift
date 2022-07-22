//
//  Color+Custom.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2021-11-08.
//

import Foundation
import SwiftUI

extension Color {
    static let textGreyInactive = Color("TextGreyInactive")
    static let primarySoftBlack = Color("PrimarySoftBlack")
    static let ctaSoftForest = Color("CTASoftForest")
    static let inputFieldsOffWhite = Color("InputFieldsOffWhite")
    static let primaryWhite = Color("PrimaryWhite")
    static let primaryIndigoGreen = Color("PrimaryIndigoGreen")
    static let successGreen = Color("SuccessGreen")
    static let alert = Color("Alert")
    static let textDarkGrey = Color("TextDarkGrey")
    static let secondaryGreenShade = Color("SecondaryGreenShade")
    static let secondaryGrey = Color("SecondaryGrey")
    static let dropShadowBlack = Color("DropShadowBlack")
    static let cardShadow = Color("CardShadow").opacity(0.87)
    static let disabled = Color("SecondaryGrey").opacity(0.4)
    static let gold = Color("Gold")
}

enum VerticalDirection {
    case TopToBottom
    case BottomToTop
}
enum HorizontalDirection {
    case LeftToRight
    case RightToLeft
}

func getPoints(verticalDirection: VerticalDirection, horizontalDirection: HorizontalDirection) -> (start: UnitPoint, end: UnitPoint) {
    switch verticalDirection {
      case VerticalDirection.TopToBottom:
          if (horizontalDirection == HorizontalDirection.LeftToRight) {
              return (start: .topLeading, end: .bottomTrailing);
          } else {
              return (start: .topTrailing, end: .bottomLeading);
          }
      case VerticalDirection.BottomToTop:
          if (horizontalDirection == HorizontalDirection.LeftToRight) {
              return (start: .bottomLeading, end: UnitPoint.topTrailing);
          }else{
              return (start: .bottomTrailing, end: .topLeading);
          }
    }
}

extension LinearGradient {
    /**
   *A function for rendering a vertical linear gradient with configurable color parameters.*
    
   - Parameters:
       - startColor:  `Color` = Color.primaryIndigoGreen
       - endColor:  `Color` = Color.ctaSoftForest
   */
    static func vertical(startColor: Color = .primaryIndigoGreen, endColor: Color = .ctaSoftForest) -> LinearGradient {
        return LinearGradient(gradient: Gradient(colors: [startColor, endColor]), startPoint: .top, endPoint: .bottom)
    }
    /**
    *A function for rendering a horizontal linear gradient with configurable color parameters.*
     
    - Parameters:
     - startColor:  `Color` = Color.primaryIndigoGreen
     - endColor:  `Color` = Color.ctaSoftForest
*/
    static func horizontal(startColor: Color = .primaryIndigoGreen, endColor: Color = .ctaSoftForest) -> LinearGradient {
        return LinearGradient(gradient: Gradient(colors: [startColor, endColor]), startPoint: .leading, endPoint: .trailing)
    }
    /**
    *A function for rendering diagonal linear gradients with configurable direction and color parameters*

    - Parameters:
        - direction:  (vertical: VerticalDirection, horizontal: HorizontalDirection) = (vertical: VerticalDirection.TopToBottom, horizontal: HorizontalDirection.LeftToRight)
        - color:  (start: Color, end: Color) = (start: Color.primaryIndigoGreen, end: Color.ctaSoftForest)
     */
    static func diagonal(
        direction: (vertical: VerticalDirection, horizontal: HorizontalDirection) = (vertical: VerticalDirection.TopToBottom, horizontal: HorizontalDirection.LeftToRight),
        color: (start: Color, end: Color) = (start: .primaryIndigoGreen, end: .ctaSoftForest)) -> LinearGradient {
            let pointCoords = getPoints(verticalDirection: direction.vertical, horizontalDirection: direction.horizontal)
            return LinearGradient(gradient: Gradient(colors: [color.start, color.end]), startPoint: pointCoords.start, endPoint: pointCoords.end);
    }
}
