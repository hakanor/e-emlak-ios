//
//  SkeletonService.swift
//  e-emlak
//
//  Created by Hakan Or on 8.01.2023.
//

import Foundation
import UIKit

struct SkeletonService {
    static let shared = SkeletonService()
    
    func showSkeletons(skeletons: [UIView]) {
        for view in skeletons {
            view.isSkeletonable = true
//            view.showAnimatedGradientSkeleton()
            view.showAnimatedSkeleton()
        }
    }
    
    func hideSkeletons(skeletons: [UIView]) {
        for view in skeletons {
            view.hideSkeleton()
        }
    }

}

