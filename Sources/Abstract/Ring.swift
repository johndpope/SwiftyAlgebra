import Foundation

public protocol Ring: AdditiveGroup, Monoid, ExpressibleByIntegerLiteral {
    associatedtype IntegerLiteralType = Int
    init(_ intValue: Int)
}

public extension Ring {
    // required init from `ExpressibleByIntegerLiteral`
    public init(integerLiteral value: Int) {
        self.init(value)
    }
    
    public static var zero: Self {
        return Self.init(0)
    }
    
    static var identity: Self {
        return Self.init(1)
    }
    
    static func **(a: Self, n: Int) -> Self {
        return (0 ..< n).reduce(Self.identity){ (res, _) in res * a }
    }
}
