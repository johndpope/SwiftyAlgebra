//: Playground - noun: a place where people can play

import Foundation
import SwiftyAlgebra

// Aliases populary used in Math.

typealias Z = IntegerNumber
typealias Q = RationalNumber
typealias R = RealNumber

let V = VertexSet(number: 10)
let s = V.simplex(0, 1, 2, 3)
let C = SimplicialChainComplex<Z>(simplices: s.allSubsimplices())

print("complex: \(C)")

let d2 = C.boundary(2)
let d1 = C.boundary(1)

let (cycles, boundaries) = d2.kerIm()
print("\ncycle: \(cycles)")

for b in boundaries {
    print(d1.appliedTo(b))
}