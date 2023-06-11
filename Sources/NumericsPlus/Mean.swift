import Numerics
import Foundation

extension Real {
    
    public static func mean<C: Collection<Self>>(_ collection: C) -> Self {
        assert(!collection.isEmpty)
        return sum(collection) / Self(collection.count)
    }
}
