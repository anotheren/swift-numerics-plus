import Numerics

extension Real {

    /// Polynomial fitting with basic error handling
    public static func polyfit<C: Collection<Self>>(x: C, y: C, degree: Int) -> [Self] {
        // Basic validation for edge cases
        guard !x.isEmpty && !y.isEmpty && x.count == y.count && degree >= 0 else {
            return [Self](repeating: 0, count: degree + 1)
        }

        // Special case: degree 0 (constant fit)
        if degree == 0 {
            return [Self.sum(y) / Self(y.count)]
        }

        // Check for sufficient data points
        guard x.count > degree else {
            return [Self](repeating: 0, count: degree + 1)
        }

        // Check for NaN/Infinity in input
        let xArray = Array(x)
        let yArray = Array(y)

        if xArray.contains(where: { !$0.isFinite }) || yArray.contains(where: { !$0.isFinite }) {
            return [Self](repeating: 0, count: degree + 1)
        }

        // Build matrix for least squares problem
        var matrix = (0..<degree+1).map { power in
            (0..<degree+1).map { col in
                let exponent = Self(power) + Self(col)
                let xs = xArray.map { x in
                    if x == 0 && exponent == 0 {
                        return 1 as Self  // 0^0 = 1 by convention
                    }
                    return pow(x, exponent)
                }
                return Self.sum(xs)
            }
        }

        // Build vector for least squares problem
        var vector = (0...degree).map { power in
            let v = zip(xArray, yArray).map { x, y in
                let powResult: Self
                if x == 0 && Self(power) == 0 {
                    powResult = 1 as Self
                } else {
                    powResult = pow(x, Self(power))
                }
                return powResult * y
            }
            return Self.sum(v)
        }

        // Gaussian elimination with partial pivoting
        for row in 0..<degree {
            // Find pivot row
            var pivotRow = row
            var maxVal = abs(matrix[row][row])

            for candidateRow in row+1..<degree+1 {
                let candidateVal = abs(matrix[candidateRow][row])
                if candidateVal > maxVal {
                    maxVal = candidateVal
                    pivotRow = candidateRow
                }
            }

            // Check for singular matrix
            let tolerance = max(Self.leastNonzeroMagnitude * 1000, Self.ulpOfOne * 1000000)
            if maxVal < tolerance {
                // Return zeros for singular matrix
                return [Self](repeating: 0, count: degree + 1)
            }

            // Swap rows if necessary
            if pivotRow != row {
                matrix.swapAt(row, pivotRow)
                vector.swapAt(row, pivotRow)
            }

            // Perform elimination
            for column in row+1..<degree+1 {
                let mult = matrix[column][row] / matrix[row][row]
                for i in row..<degree+1 {
                    matrix[column][i] -= mult * matrix[row][i]
                }
                vector[column] -= mult * vector[row]
            }
        }

        // Back substitution
        var ans = [Self](repeating: 0, count: degree+1)
        for row in (0...degree).reversed() {
            var sum: Self = 0
            for column in stride(from: row+1, to: degree+1, by: 1) {
                sum += matrix[row][column] * ans[column]
            }

            // Check for division by zero
            let tolerance = max(Self.leastNonzeroMagnitude * 1000, Self.ulpOfOne * 1000000)
            if abs(matrix[row][row]) < tolerance {
                ans[row] = 0
            } else {
                ans[row] = (vector[row] - sum) / matrix[row][row]
            }
        }

        let result = ans.reversed()

        // Final validation - return zeros if result contains invalid values
        if result.contains(where: { !$0.isFinite }) {
            return [Self](repeating: 0, count: degree + 1)
        }

        return Array(result)
    }
}
