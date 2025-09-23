import Numerics
import Foundation

extension Real {

    /// Polynomial fitting with robust error handling
    public static func polyfit<C: Collection<Self>>(x: C, y: C, degree: Int) -> [Self] {
        polyfit(x: x, y: y, degree: degree, debug: false)
    }

    /// Debug version of polynomial fitting with detailed logging
    public static func polyfit<C: Collection<Self>>(x: C, y: C, degree: Int, debug: Bool) -> [Self] {
        // Enhanced input validation
        guard !x.isEmpty && !y.isEmpty else {
            if debug { print("🚫 ERROR: Empty input arrays, returning zeros") }
            return [Self](repeating: 0, count: degree + 1)
        }

        guard x.count == y.count else {
            if debug { print("🚫 ERROR: Mismatched array sizes (x: \(x.count), y: \(y.count)), returning zeros") }
            return [Self](repeating: 0, count: degree + 1)
        }

        guard degree >= 0 else {
            if debug { print("🚫 ERROR: Negative degree (\(degree)), returning zeros") }
            return [Self](repeating: 0, count: degree + 1)
        }

        // Special case: degree 0 (constant fit)
        if degree == 0 {
            let meanValue = Self.sum(y) / Self(y.count)
            if debug { print("✓ Degree 0 fit: mean = \(meanValue)") }
            return [meanValue]
        }

        // Check for sufficient data points
        guard x.count > degree else {
            if debug { print("🚫 ERROR: Insufficient data points (\(x.count)) for degree (\(degree)), returning zeros") }
            return [Self](repeating: 0, count: degree + 1)
        }

        // Check for NaN/Infinity in input
        let xArray = Array(x)
        let yArray = Array(y)

        if debug {
            print("📊 Input analysis:")
            print("  - X range: \(xArray.min() ?? 0) to \(xArray.max() ?? 0)")
            print("  - Y range: \(yArray.min() ?? 0) to \(yArray.max() ?? 0)")
            print("  - Data points: \(xArray.count)")
        }

        if xArray.contains(where: { !$0.isFinite }) || yArray.contains(where: { !$0.isFinite }) {
            if debug { print("🚫 ERROR: Input contains NaN or Infinity, returning zeros") }
            return [Self](repeating: 0, count: degree + 1)
        }

        // Check if all y values are identical (perfectly collinear)
        let firstY = yArray.first!
        let allIdentical = yArray.allSatisfy { $0 == firstY }
        if allIdentical {
            if debug { print("📈 All y values are identical, returning horizontal line") }
            // Return horizontal line (slope = 0, intercept = y_value)
            var result = [Self](repeating: 0, count: degree + 1)
            result[0] = 0  // slope = 0
            result[1] = firstY  // intercept = y_value
            return result
        }

        if debug { print("🔧 Building matrix and vector...") }

        // Enhanced matrix construction with numerical stability
        var matrix = (0..<degree+1).map { power in
            (0..<degree+1).map { (col) -> Self in
                let xs = xArray.map { pow($0, Self(power) + Self(col)) }
                let sum = Self.sum(xs)

                // Check for numerical overflow/underflow
                if !sum.isFinite {
                    if debug { print("⚠️ WARNING: Matrix construction overflow at power \(power), col \(col)") }
                    return 0
                }
                return sum
            }
        }

        // Enhanced vector construction with numerical stability
        var vector = (0...degree).map { power -> Self in
            let v = zip(xArray, yArray).map { pow($0, Self(power)) * $1 }
            let sum = Self.sum(v)

            // Check for numerical overflow/underflow
            if !sum.isFinite {
                if debug { print("⚠️ WARNING: Vector construction overflow at power \(power)") }
                return 0
            }
            return sum
        }

        if debug {
            print("📐 Matrix dimensions: \(matrix.count)x\(matrix.first?.count ?? 0)")
            print("📐 Vector dimensions: \(vector.count)")
        }

        // Enhanced Gaussian elimination with better numerical stability
        for row in 0..<degree {
            // Find the pivot row
            var pivotRow = row
            var maxVal = abs(matrix[row][row])

            for candidateRow in row+1..<degree+1 {
                let candidateVal = abs(matrix[candidateRow][row])
                if candidateVal > maxVal {
                    maxVal = candidateVal
                    pivotRow = candidateRow
                }
            }

            // Enhanced tolerance calculation
            let tolerance = max(
                Self.leastNonzeroMagnitude * 1000,
                Self.ulpOfOne * 1000
            )

            if maxVal < tolerance {
                if debug { print("⚠️ WARNING: Matrix is singular or nearly singular at row \(row), maxVal: \(maxVal)") }
                // Set remaining rows to zero
                for i in row..<degree+1 {
                    matrix[row][i] = 0
                }
                vector[row] = 0
                continue
            }

            // Swap rows if necessary
            if pivotRow != row {
                matrix.swapAt(row, pivotRow)
                vector.swapAt(row, pivotRow)
            }

            // Perform elimination with better numerical stability
            for column in row+1..<degree+1 {
                let mult = matrix[column][row] / matrix[row][row]

                // Check for numerical issues
                if !mult.isFinite {
                    if debug { print("⚠️ WARNING: Numerical instability in elimination at row \(row), column \(column)") }
                    continue
                }

                for i in row..<degree+1 {
                    let oldValue = matrix[column][i]
                    matrix[column][i] -= mult * matrix[row][i]

                    // Check for numerical issues
                    if !matrix[column][i].isFinite {
                        if debug { print("⚠️ WARNING: Matrix element became infinite/NaN at [\(column)][\(i)]") }
                        matrix[column][i] = oldValue // Revert
                    }
                }

                let oldVector = vector[column]
                vector[column] -= mult * vector[row]

                // Check for numerical issues
                if !vector[column].isFinite {
                    if debug { print("⚠️ WARNING: Vector element became infinite/NaN at \(column)") }
                    vector[column] = oldVector // Revert
                }
            }
        }

        // Enhanced back substitution
        var ans = [Self](repeating: 0, count: degree+1)
        for row in (0...degree).reversed() {
            var sum: Self = 0
            for column in stride(from: row+1, to: degree+1, by: 1) {
                sum += matrix[row][column] * ans[column]
            }

            // Enhanced safety check
            let tolerance = max(
                Self.leastNonzeroMagnitude * 1000,
                Self.ulpOfOne * 1000
            )

            if abs(matrix[row][row]) < tolerance {
                if debug { print("⚠️ WARNING: Division by near-zero in back substitution at row \(row)") }
                ans[row] = 0
            } else {
                let result = (vector[row] - sum) / matrix[row][row]

                // Final sanity check
                if !result.isFinite {
                    if debug { print("⚠️ WARNING: Final result is infinite/NaN at row \(row)") }
                    ans[row] = 0
                } else {
                    ans[row] = result
                }
            }
        }

        let finalResult = ans.reversed()

        // Final validation
        if finalResult.contains(where: { !$0.isFinite }) {
            if debug { print("🚫 ERROR: Final result contains infinite/NaN values, returning zeros") }
            return [Self](repeating: 0, count: degree + 1)
        }

        if debug {
            print("✅ SUCCESS: Polyfit completed successfully")
            print("📈 Result: \(finalResult)")
        }

        return Array(finalResult)
    }
}
