import Numerics
import Foundation

extension Real {
    
    /// 平均数
    public static func mean<C: Collection<Self>>(_ collection: C) -> Self {
        assert(!collection.isEmpty)
        return sum(collection) / Self(collection.count)
    }
}
