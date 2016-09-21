//
//  Products.swift
//  Beto
//
//  Created by Vince Boogie on 9/20/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import Foundation

public struct Products {
    private static let Prefix = "com.redgarage.Beto."
    
    public static let RemoveAds = Prefix + "RemoveAds"
    
    private static let productIdentifiers: Set<ProductIdentifier> = [Products.RemoveAds]
    
    public static let store = IAPHelper(productIds: Products.productIdentifiers)
}

func resourceNameForProductIdentifier(productIdentifier: String) -> String? {
    return productIdentifier.componentsSeparatedByString(".").last
}