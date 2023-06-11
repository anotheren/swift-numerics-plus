import Numerics
import Foundation

extension Real {
    
    public static func variance(_ array: [Self], ddof: Int = 0) -> Self {
        assert(array.count > 1)
        
        let mean = mean(array)
        let squaredDiff = array.map { val in
            let diff = val - mean
            return diff * diff
        }
        let variance = sum(squaredDiff) / Self(array.count - ddof)
        return variance
    }
}
