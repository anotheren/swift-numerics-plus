import Numerics
import Foundation

extension Real {
    
    /// 线性拟合
    public static func polyfit<C: Collection<Self>>(x: C, y: C, degree: Int) -> [Self] {
        assert(!x.isEmpty && !y.isEmpty && x.count == y.count && degree >= 1)
        
        // Matrixize the one-dimensional array of x
        var matrix = (0..<degree+1).map { power in
            (0..<degree+1).map { (col) -> Self in
                let xs = x.map { pow($0, Self(power)+Self(col)) }
                return sum(xs)
            }
        }
        
        // Convert the one-dimensional array of y into a column matrix
        var vector = (0...degree).map { power -> Self in
            let v = zip(x, y).map { pow($0, Self(power)) * $1 }
            return sum(v)
        }
        
        // Convert the matrix to an upper triangular matrix
        for row in 0..<degree {
            for column in row+1..<degree+1 {
                let mult = matrix[column][row] / matrix[row][row]
                for i in row..<degree+1 {
                    matrix[column][i] -= mult * matrix[row][i]
                }
                vector[column] -= mult * vector[row]
            }
        }
        
        // Back substitution to solve
        var ans = [Self](repeating: 0, count: degree+1)
        for row in (0...degree).reversed() {
            var sum: Self = 0
            for column in stride(from: row+1, to: degree+1, by: 1) {
                sum += matrix[row][column] * ans[column]
            }
            ans[row] = (vector[row] - sum) / matrix[row][row]
        }
        
        return ans.reversed()
    }
}
