/*
* Copyright (c) 2015 Razeware LLC
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
import UIKit
 /*
Circle CircleFitByTaubin (Data& data)
/*
Circle fit to a given set of data points (in 2D)

This is an algebraic fit, due to Taubin, based on the journal article

G. Taubin, "Estimation Of Planar Curves, Surfaces And Nonplanar
Space Curves Defined By Implicit Equations, With
Applications To Edge And Range Image Segmentation",
IEEE Trans. PAMI, Vol. 13, pages 1115-1138, (1991)

Input:  data     - the class of data (contains the given points):

data.n   - the number of data points
data.X[] - the array of X-coordinates
data.Y[] - the array of Y-coordinates

Output:
circle - parameters of the fitting circle:

circle.a - the X-coordinate of the center of the fitting circle
circle.b - the Y-coordinate of the center of the fitting circle
circle.r - the radius of the fitting circle
circle.s - the root mean square error (the estimate of sigma)
circle.j - the total number of iterations

The method is based on the minimization of the function

sum [(x-a)^2 + (y-b)^2 - R^2]^2
F = -------------------------------
sum [(x-a)^2 + (y-b)^2]

This method is more balanced than the simple Kasa fit.

It works well whether data points are sampled along an entire circle or
along a small arc.

It still has a small bias and its statistical accuracy is slightly
lower than that of the geometric fit (minimizing geometric distances),
but slightly higher than that of the very similar Pratt fit.
Besides, the Taubin fit is slightly simpler than the Pratt fit

It provides a very good initial guess for a subsequent geometric fit.

Nikolai Chernov  (September 2012)
*/
*/

let IterMAX = 8

struct CircleResult {
  var center: CGPoint
  var radius: CGFloat
  var error: CGFloat
  var j: Int

  init() {
    center = CGPoint.zero
    radius = 0
    error = 0
    j = 0
  }
}

func fitCircle(_ points: [CGPoint]) -> CircleResult {
  let dataLength: CGFloat = CGFloat(points.count)
  var mean: CGPoint = CGPoint.zero

  for p in points {
    mean.x += p.x
    mean.y += p.y
  }
  mean.x = mean.x / dataLength
  mean.y = mean.y / dataLength

  //     computing moments

  var Mxx = 0.0 as CGFloat
  var Myy = 0.0 as CGFloat
  var Mxy = 0.0 as CGFloat
  var Mxz = 0.0 as CGFloat
  var Myz = 0.0 as CGFloat
  var Mzz = 0.0 as CGFloat

  for p in points {
    let Xi = p.x - mean.x
    let Yi = p.y - mean.y
    let Zi = Xi*Xi + Yi+Yi

    Mxy += Xi * Yi
    Mxx += Xi * Xi
    Myy += Yi * Yi
    Mxz += Xi * Zi
    Myz += Yi * Zi
    Mzz += Zi * Zi
  }
  Mxx /= dataLength
  Myy /= dataLength
  Mxy /= dataLength
  Mxz /= dataLength
  Myz /= dataLength
  Mzz /= dataLength

  //      computing coefficients of the characteristic polynomial

  let Mz = Mxx + Myy
  let Cov_xy = Mxx*Myy - Mxy*Mxy
  let Var_z = Mzz - Mz*Mz
  let A3 = 4*Mz
  let A2 = -3*Mz*Mz - Mzz
  let A1 = Var_z*Mz + 4*Cov_xy*Mz - Mxz*Mxz - Myz*Myz
  let A0 = Mxz*(Mxz*Myy - Myz*Mxy) + Myz*(Myz*Mxx - Mxz*Mxy) - Var_z*Cov_xy
  let A22 = A2 + A2
  let A33 = A3 + A3 + A3

  //    finding the root of the characteristic polynomial
  //    using Newton's method starting at x=0
  //     (it is guaranteed to converge to the right root)

  var x: CGFloat = 0
  var y = A0
  var iter = 0
  //for iter = 0; iter<IterMAX; iter += 1  // usually, 4-6 iterations are enough
    while (iter < IterMAX)
  {
    let Dy = A1 + x*(A22 + A33*x)
    let xnew = x - y/Dy
    if ((xnew == x)||(!(Double(xnew) < Double.infinity))) { break }
    let ynew = A0 + xnew*(A1 + xnew*(A2 + xnew*A3))
    if (abs(ynew)>=abs(y)) { break }
    x = xnew;  y = ynew
    iter += 1
  }

  //       computing paramters of the fitting circle

  let DET = x*x - x*Mz + Cov_xy
  let Xcenter = (Mxz*(Myy - x) - Myz*Mxy)/DET/2.0
  let Ycenter = (Myz*(Mxx - x) - Mxz*Mxy)/DET/2.0

  //       assembling the output

  var circle = CircleResult()

  circle.center.x = Xcenter + mean.x
  circle.center.y = Ycenter + mean.y
  circle.radius = sqrt(Xcenter*Xcenter + Ycenter*Ycenter + Mz)
  circle.error = Sigma(points,circle: circle)
  circle.j = iter  //  return the number of iterations, too

  return circle

}


//****************** Sigma ************************************
//
//   estimate of Sigma = square root of RSS divided by N
//   gives the root-mean-square error of the geometric circle fit


func Sigma(_ data: [CGPoint], circle: CircleResult) -> CGFloat {

  var sum: CGFloat = 0.0

  for p in data {
    let dx = p.x - circle.center.x
    let dy = p.y - circle.center.y
    let s = (sqrt(dx*dx+dy*dy) - circle.radius) / circle.radius //<- added / c.r to give normalized result
    sum += s*s
  }

  return sqrt(sum / CGFloat(data.count))
}
 
 
