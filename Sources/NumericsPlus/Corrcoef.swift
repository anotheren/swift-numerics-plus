import Numerics
import Foundation

extension Real {
    
    public static func corrcoef<C: Collection<Self>>(x: C, y: C) -> Self {
        assert(x.count == y.count && x.count > 1)
        let meanX = mean(x)
        let meanY = mean(y)
        let sumXY = sum(zip(x, y).map {
            ($0.0 - meanX) * ($0.1 - meanY)
        })
        let sumX2 = sum(x.map {
            pow($0 - meanX, 2)
        })
        let sumY2 = sum(y.map {
            pow($0 - meanY, 2)
        })
        return sumXY / sqrt(sumX2 * sumY2)
    }
}
