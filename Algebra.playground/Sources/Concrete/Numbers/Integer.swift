import Foundation

public typealias IntegerNumber = Int

extension IntegerNumber: Ring {
    static private var primes: [IntegerNumber] = []
    
    public var primeFactors: [IntegerNumber] {
        var result: [IntegerNumber] = []
        var q = self
        
        let ps = IntegerNumber.primes(upTo: self)
        for p in ps {
            while q % p == 0 {
                q /= p
                result.append(p)
            }
        }
        
        return result
    }
    
    public static func primes(upTo n: IntegerNumber) -> [IntegerNumber] {
        if let last = primes.last, n <= last {
            return primes.filter{ $0 <= n }
        }
        
        var result: [IntegerNumber] = []
        var seive = primes + Array( (primes.last ?? 1) + 1 ... abs(n) )
        
        while let a = seive.first {
            seive = seive.filter{ $0 % a > 0 }
            result.append(a)
        }
        
        primes = result
        return result
    }
}

extension IntegerNumber: EuclideanRing {
    public var degree: Int {
        return abs(self)
    }
    
    public static func eucDiv(_ a: IntegerNumber, _ b: IntegerNumber) -> (q: IntegerNumber, r: IntegerNumber) {
        let q = a / b
        return (q: q, r: a - q * b)
    }
}
