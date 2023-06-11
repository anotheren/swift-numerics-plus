import Numerics
import Foundation

extension Real {
    
    public static func sum<C: Collection<Self>>(_ collection: C) -> Self {
        collection.reduce(0, +)
    }
}
