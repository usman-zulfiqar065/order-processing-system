# README

# Order Processing System

## Code Features
  1. It contains two models (user and order), There is a required scope in order model to fetch all completed buy orders
  2. There is a method 'process_order' in order model to update order status
  3. There is a method (Query) in user model to get total quantity of completed orders for that specified user
  4. There are two test files for both Models to test the functionality 

## Getting Started

These instructions will help you set up the project and run the tests on your local machine.

### Prerequisites

- Ruby (version 3.2.2)
- Rails (version 7.0.8)
- Bundler

### Installing Dependencies

Install the required gems using Bundler:

```bash
bundle install
```

### Run rspec to run test cases
