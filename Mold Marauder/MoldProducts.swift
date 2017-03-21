/*
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation

public struct MoldProducts {
  
  public static let tinyDiamonds = "com.SpaceyDreams.MoldMarauder.mold_99_cent_diamond"
    public static let smallDiamonds = "com.SpaceyDreams.MoldMarauder.mold_299_cent_diamond"
    public static let mediumDiamonds = "com.SpaceyDreams.MoldMarauder.mold_999_cent_diamond"
    public static let largeDiamonds = "com.SpaceyDreams.MoldMarauder.mold_4999_cent_diamond"
   
  static let productIdentifiers: Set<ProductIdentifier> =
    [MoldProducts.tinyDiamonds,
     MoldProducts.smallDiamonds,
     MoldProducts.mediumDiamonds,
     MoldProducts.largeDiamonds]

  public static let store = IAPHelper(productIds: MoldProducts.productIdentifiers)

  public static func isProductPurchased(_ productIdentifier: ProductIdentifier) -> Bool {
    if (productIdentifier == MoldProducts.tinyDiamonds || productIdentifier == MoldProducts.smallDiamonds || productIdentifier == MoldProducts.mediumDiamonds || productIdentifier == MoldProducts.largeDiamonds) {
      return false
    } else {
      return MoldProducts.store.isProductPurchased(productIdentifier)
    }
  }

}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
  return productIdentifier.components(separatedBy: ".").last
}

