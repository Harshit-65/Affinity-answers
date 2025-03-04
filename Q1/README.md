# PIN Code Validator

This program helps validate PIN codes in addresses by checking if they correspond to the actual location mentioned in the address.

## How it Works

The program uses the postalpincode.in API to validate Indian PIN codes against addresses. It:

1. Extracts the PIN code from the address
2. Fetches location data for that PIN code
3. Compares the API response with the address components to verify the match

## Files

- `pin_validator.py`: Main implementation of the PIN code validation logic
- `test_pin_validator.py`: Test cases to verify the validator works correctly

## Test Cases

I've included various test cases to cover different scenarios:

1. Valid addresses with matching PIN codes:

   - Complete addresses with all components
   - Addresses with slight variations in locality names
   - Addresses with different formatting

2. Invalid cases:
   - Wrong PIN code for the given address
   - Incomplete addresses
   - Invalid PIN codes
   - Missing PIN codes

## How to Run

1. Install dependencies:

```bash
pip install requests
```

2. Run the validator:

```bash
python pin_validator.py
```

3. Run tests:

```bash
python test_pin_validator.py
```

## Dependencies

- Python 3.x
- requests library
