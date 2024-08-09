//
//  ExtensionStoryboard.swift
//
//

import Foundation
import UIKit
protocol StoryboardIdentifiable {
  static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
  static var storyboardIdentifier: String {
    return String(describing: self)
  }
}

extension UIViewController : StoryboardIdentifiable { }

extension UIStoryboard {
  /// The uniform place where we state all the storyboard we have in our application
  enum Storyboard:String {
    case main
    case User
    case Dashboard
    case Address
    case Order
    case Professional
    var filename:String{
      switch self {
      default: return rawValue.capitalized
      }
    }
  }
  
  // MARK: - Convenience Initializers
  
  convenience init(storyboard: Storyboard, bundle: Bundle? = nil) {
    self.init(name: storyboard.filename, bundle: bundle)
  }
  
  // MARK: - View Controller Instantiation from Generics
  
  func initVC<T: UIViewController>() -> T where T: StoryboardIdentifiable {
    guard let vc = self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
      fatalError("Couldn't instantiate view controller with identifier \(T.storyboardIdentifier) ")
    }
    return vc
  }
}
