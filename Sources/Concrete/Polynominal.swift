import Foundation

// concrete Polynomial-type over a field

public struct Polynomial<K: Field>: EuclideanRing, Module, CustomStringConvertible {
    public typealias R = K
    public let coeffs: [K]
    
    public init(_ value: Int) {
        let a = K(value)
        self.init([a])
    }
    
    public init(degree: Int, gen: ((Int) -> K)) {
        let coeffs = (0 ... degree).map(gen)
        self.init(coeffs)
    }
    
    public init(_ coeffs: K...) {
        self.init(coeffs)
    }
    
    public init(_ coeffs: [K]) {
        self.coeffs = coeffs
    }
    
    public var degree: Int {
        let n = coeffs.count - 1
        for i in 0 ..< n {
            if coeffs[n - i] != 0 {
                return n - i
            }
        }
        return 0
    }
    
    public var leadCoeff: K {
        return coeffs[degree]
    }
    
    public func coeff(_ i: Int) -> K {
        return i < coeffs.count ? coeffs[i] : 0
    }
    
    public func apply(_ x: K) -> K {
        return (0 ... degree).reduce(0) { (sum, i) -> K in
            sum + (coeffs[i] * (x ** i))
        }
    }
    
    public func map(_ f: ((K) -> K)) -> Polynomial<K> {
        return Polynomial<K>.init(coeffs.map(f))
    }
    
    public var derivative: Polynomial<K> {
        return Polynomial<K>.init(degree: degree - 1) {
            K($0 + 1) * coeff($0 + 1)
        }
    }
    
    public func toMonic() -> Polynomial<K> {
        let a = leadCoeff
        return self.map{ $0 / a }
    }
    
    public static var indeterminate: Polynomial<K> {
        return Polynomial<K>(0, 1)
    }
    
    public static func eucDiv<K: Field>(_ f: Polynomial<K>, _ g: Polynomial<K>) -> (q: Polynomial<K>, r: Polynomial<K>) {
        if g == 0 {
            fatalError("divide by 0")
        }
        
        func eucDivMonomial(_ f: Polynomial<K>, _ g: Polynomial<K>) -> (q: Polynomial<K>, r: Polynomial<K>) {
            let n = f.degree - g.degree
            
            if n < 0 {
                return (0, f)
            } else {
                let a = f.leadCoeff / g.leadCoeff
                let q = Monomial(degree: n, coeff: a)
                let r = f - q * g
                return (q, r)
            }
        }
        
        return (0 ... max(0, f.degree - g.degree))
            .reversed()
            .reduce( (0, f) ) { (result: (Polynomial<K>, Polynomial<K>), degree: Int) in
                let (q, r) = result
                let m = eucDivMonomial(r, g)
                return (q + m.q, m.r)
        }
    }
}

public func Monomial<K>(degree d: Int, coeff a: K) -> Polynomial<K> {
    return Polynomial(degree: d) { $0 == d ? a : 0 }
}

public func ==<K: Field>(f: Polynomial<K>, g: Polynomial<K>) -> Bool {
    return (f.degree == g.degree) &&
        (0 ... f.degree).reduce(true) { $0 && (f.coeff($1) == g.coeff($1)) }
}

public func +<K: Field>(f: Polynomial<K>, g: Polynomial<K>) -> Polynomial<K> {
    return Polynomial<K>(degree: max(f.degree, g.degree)) { f.coeff($0) + g.coeff($0) }
}

public prefix func -<K: Field>(f: Polynomial<K>) -> Polynomial<K> {
    return f.map { -$0 }
}

public func *<K: Field>(f: Polynomial<K>, g: Polynomial<K>) -> Polynomial<K> {
    return Polynomial<K>(degree: f.degree + g.degree) {
        (k: Int) in
        (max(0, k - g.degree) ... min(k, f.degree)).reduce(0) {
            (res:K, i:Int) in res + f.coeff(i) * g.coeff(k - i)
        }
    }
}

public func *<K: Field>(r: K, f: Polynomial<K>) -> Polynomial<K> {
    return f.map { r * $0 }
}

public func *<K: Field>(f: Polynomial<K>, r: K) -> Polynomial<K> {
    return f.map { $0 * r }
}

extension Polynomial {
    public var description: String {
        let res = coeffs.enumerated().flatMap {
            (n: Int, a: K) -> String? in
            switch(a, n) {
            case ( 0, _): return nil
            case ( _, 0): return "\(a)"
            case ( 1, 1): return "x"
            case (-1, 1): return "-x"
            case ( _, 1): return "\(a)x"
            case ( 1, _): return "x^\(n)"
            case (-1, _): return "-x^\(n)"
            default: return "\(a)x^\(n)"
            }
            }.reversed().joined(separator: " + ")
        return res.isEmpty ? "0" : res
    }
}
