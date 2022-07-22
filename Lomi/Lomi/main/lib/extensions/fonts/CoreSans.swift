//
//  CoreSans.swift
//  Lomi
//
//  Created by Peter Harding on 2021-12-21.
//

import Foundation
import UIKit
import SwiftUI

struct CoreSans {
    // MARK: text styles overrides
    public static var body: Font {
        return Font.custom("CoreSansC-45Regular", size: UIFont.preferredFont(forTextStyle: .body).pointSize)
    }
    
    public static var caption: Font {
        return Font.custom("CoreSansC-45Regular", size: UIFont.preferredFont(forTextStyle: .caption1).pointSize)
    }
    
    public static var callout: Font {
        return Font.custom("CoreSansC-45Regular", size: UIFont.preferredFont(forTextStyle: .callout).pointSize)
    }
    
    public static var footnote: Font {
        return Font.custom("CoreSansC-45Regular", size: UIFont.preferredFont(forTextStyle: .footnote).pointSize)
    }
    
    public static var headline: Font {
        return Font.custom("CoreSansC-45Regular", size: UIFont.preferredFont(forTextStyle: .headline).pointSize)
    }
    
    public static var largeTitle: Font {
        return Font.custom("CoreSansC-65Bold", size: UIFont.preferredFont(forTextStyle: .largeTitle).pointSize)
    }
    
    public static var subheadLine: Font {
        return Font.custom("CoreSansC-35Light", size: UIFont.preferredFont(forTextStyle: .subheadline).pointSize)
    }
    
    public static var title: Font {
        return Font.custom("CoreSansC-65Bold", size: UIFont.preferredFont(forTextStyle: .title1).pointSize)
    }
    
    // MARK: body style variations
    public static var bold: Font {
        return Font.custom("CoreSansC-65Bold", size: UIFont.preferredFont(forTextStyle: .body).pointSize)
    }
    
    public static var semibold: Font {
        return Font.custom("CoreSansC-55Medium", size: UIFont.preferredFont(forTextStyle: .body).pointSize)
    }
    
    public static var light: Font {
        return Font.custom("CoreSansC-35Light", size: UIFont.preferredFont(forTextStyle: .body).pointSize)
    }
    
}
