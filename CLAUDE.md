# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Swift package that extends Apple's Swift Numerics library with additional numerical functions, providing interfaces similar to Python's NumPy. The package adds statistical and mathematical operations to the `Real` protocol from Swift Numerics.

## Build Commands

- Build the package: `swift build`
- Run tests: `swift test`
- Run specific test: `swift test --filter NumericsPlusTests.testFunctionName`

## Architecture

The codebase follows a modular architecture where each mathematical function is implemented as a separate Swift file extending the `Real` protocol:

- **Sources/NumericsPlus/**: Core library files
  - `Sum.swift`: Basic summation operation
  - `Mean.swift`: Mean calculation
  - `Variance.swift`: Variance and standard deviation calculations
  - `Corrcoef.swift`: Pearson correlation coefficient
  - `Polyfit.swift`: Polynomial regression fitting using Gaussian elimination

- **Tests/NumericsPlusTests/**: Unit tests for all functions

## Key Dependencies

- **Swift Numerics** (v1.0.2+): Apple's official numerical computing library, provides the `Real` protocol that all functions extend

## Code Patterns

All functions follow these patterns:
1. Extend the `Real` protocol from Swift Numerics
2. Use generic collections (`Collection<Self>`) where possible
3. Include assertions for preconditions
4. Use static methods on the `Real` type
5. Chinese comments in docstrings describing the mathematical operation

## Mathematical Functions

### Statistical Functions
- `sum()`: Sum of collection elements
- `mean()`: Arithmetic mean
- `variance()`: Variance with optional degrees of freedom (ddof parameter)
- `std()`: Standard deviation with optional ddof
- `corrcoef()`: Pearson correlation coefficient between two collections

### Mathematical Functions
- `polyfit()`: Polynomial regression fitting using Gaussian elimination for solving linear systems

## Testing

Tests use XCTest and focus on numerical accuracy with tolerance-based assertions. Test data uses realistic floating-point values rather than simple integers to validate precision.