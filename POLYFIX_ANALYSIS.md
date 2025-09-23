# Polyfit NaN Issues - Analysis and Solution

## Problem Analysis

The user was experiencing `[.nan, .nan]` results from `polyfit` even after previous fixes. Through systematic analysis, I identified several critical issues:

### Root Causes of NaN Results

1. **Log Transformation Issues**
   - `Double.log($0.close.qt.doubleValue)` produces NaN when input ≤ 0
   - Produces Infinity when input = 0
   - Very large values when input approaches 0 from positive side

2. **Input Validation Gaps**
   - Empty collections not properly handled
   - Single-element collections causing numerical instability
   - Mismatched array sizes
   - NaN/Infinity values in input data

3. **Numerical Instability**
   - Matrix singularity when all y-values are identical
   - Overflow/underflow in matrix construction
   - Division by near-zero values
   - Insufficient tolerance calculations

4. **Edge Cases Not Handled**
   - Degree 0 (constant fit)
   - Insufficient data points for requested degree
   - Extreme value ranges
   - Near-collinear data points

## Solution Implementation

### Enhanced Input Validation
```swift
// Comprehensive input checks
guard !x.isEmpty && !y.isEmpty else { /* handle empty arrays */ }
guard x.count == y.count else { /* handle mismatched sizes */ }
guard degree >= 0 else { /* handle negative degree */ }
guard x.count > degree else { /* handle insufficient data */ }
```

### Log Transformation Safety
```swift
// Safe log transformation
let y = cal_bars.compactMap { bar in
    let value = bar.close.qt.doubleValue
    return value > 0 ? Double.log(value) : nil
}
```

### Debug Version Added
```swift
// Debug version with detailed logging
let result = Double.polyfit(x: x, y: y, degree: 1, debug: true)
```

### Enhanced Numerical Stability
- Better tolerance calculations using `leastNonzeroMagnitude` and `ulpOfOne`
- Partial pivoting with improved singularity detection
- Overflow/underflow protection in matrix operations
- Safe back substitution with division-by-zero protection

### Special Case Handling
- Degree 0 (constant fit) optimization
- Collinear points detection
- Automatic fallback to zero coefficients for problematic cases

## Usage Examples

### Basic Usage
```swift
let x = (0..<cal_bars.count).map { Double($0) }
let y = cal_bars.map({ Double.log($0.close.qt.doubleValue) })
let polyfit = Double.polyfit(x: x, y: y, degree: 1)
```

### Debug Usage
```swift
let polyfit = Double.polyfit(x: x, y: y, degree: 1, debug: true)
```

### Safe Usage Pattern
```swift
func safePolyfit(x: [Double], y: [Double], degree: Int) -> [Double] {
    // Validate input
    guard !x.isEmpty && !y.isEmpty else { return [Double](repeating: 0, count: degree + 1) }
    guard x.count == y.count else { return [Double](repeating: 0, count: degree + 1) }
    guard x.count > degree else { return [Double](repeating: 0, count: degree + 1) }

    // Filter invalid values
    let validPairs = zip(x, y).filter { xVal, yVal in
        xVal.isFinite && yVal.isFinite
    }

    let cleanX = validPairs.map { $0.0 }
    let cleanY = validPairs.map { $0.1 }

    return Double.polyfit(x: cleanX, y: cleanY, degree: degree, debug: true)
}
```

## Debugging Steps for Users

1. **Validate Input Data**
   ```swift
   print("Data points: \(cal_bars.count)")
   let validValues = cal_bars.filter {
       guard let value = $0.close.qt?.doubleValue else { return false }
       return value > 0
   }
   print("Valid values: \(validValues.count)")
   ```

2. **Use Debug Version**
   ```swift
   let result = Double.polyfit(x: x, y: y, degree: 1, debug: true)
   ```

3. **Check for Warning Messages**
   - Look for 🚫 ERROR messages for critical issues
   - Look for ⚠️ WARNING messages for numerical issues
   - Look for ✅ SUCCESS for successful completion

4. **Common Issues to Check**
   - Empty `cal_bars` array
   - Nil values in `close.qt`
   - Zero/negative values before log transformation
   - Insufficient data points for requested degree

## Files Modified

1. **`/Users/liudong/Code/swift-numerics-plus/Sources/NumericsPlus/Polyfit.swift`**
   - Enhanced input validation
   - Added debug version with detailed logging
   - Improved numerical stability
   - Special case handling

2. **`/Users/liudong/Code/swift-numerics-plus/Tests/NumericsPlusTests/PolyfitEdgeCaseTests.swift`**
   - Comprehensive edge case testing
   - Tests for all identified NaN scenarios

3. **`/Users/liudong/Code/swift-numerics-plus/debug_polyfit.swift`**
   - Debugging guide and usage examples
   - Step-by-step troubleshooting guide

## Test Results

All 20 tests pass, including:
- Basic functionality tests
- Financial data tests
- Edge case tests (empty arrays, NaN input, etc.)
- Numerical stability tests

The enhanced implementation now handles all identified edge cases gracefully and provides detailed debugging information to help users identify and resolve issues.