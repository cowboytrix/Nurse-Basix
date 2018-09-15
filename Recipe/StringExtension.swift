//
//  UULabelExtension.swift
//  Recipe
//
//  Copyright © 2015 dmbTEAM. All rights reserved.
//

import UIKit

extension NSString {

    func height(_ font: UIFont?, width: CGFloat ) -> CGFloat {
        let attributes = [NSAttributedStringKey.font : font!]
        let rect = self.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes, context: nil)

        return rect.height
    }
}
