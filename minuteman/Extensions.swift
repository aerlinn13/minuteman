//
//  Extensions.swift
//  minuteman
//
//  Created by Danil Chernyshev on 05/07/2022.
//

import UIKit
import CoreData

extension String {

    func image() -> UIImage? {
        let size = CGSize(width: 100, height: 100)
        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        UIColor.clear.set()

        let stringBounds = (self as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 75)])
        let originX = (size.width - stringBounds.width)/2
        let originY = (size.height - stringBounds.height)/2
        let rect = CGRect(origin: CGPoint(x: originX, y: originY), size: size)
        UIRectFill(rect)

        (self as NSString).draw(in: rect, withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 75)])

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

}

extension NSManagedObject {
    
    convenience init(context: NSManagedObjectContext) {
        let name = String(describing: type(of: self))
        let entity = NSEntityDescription.entity(forEntityName: name, in: context)!
        self.init(entity: entity, insertInto: context)
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(
           red:   .random(),
           green: .random(),
           blue:  .random(),
           alpha: 1.0
        )
    }
    
    class func color(data:Data) -> UIColor? {
              return try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UIColor
         }

         func encode() -> Data? {
              return try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
         }
}

