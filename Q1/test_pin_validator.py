import unittest
from unittest.mock import patch
from pin_validator import validate_address

# A fake response class to simulate requests.get() responses
class FakeResponse:
    def __init__(self, json_data):
        self._json = json_data

    def json(self):
        return self._json

# A helper function to simulate different API responses based on the URL
def fake_requests_get(url, *args, **kwargs):
    if "560050" in url:
        return FakeResponse([
            {
                "Message": "Number of pincode(s) found:4",
                "Status": "Success",
                "PostOffice": [
                    {"Name": "Ashoknagar (Bangalore)"},
                    {"Name": "Banashankari"},
                    {"Name": "Dasarahalli(Srinagar)"},
                    {"Name": "State Bank Of Mysore Colony"}
                ]
            }
        ])
    elif "560095" in url:
        return FakeResponse([
            {
                "Message": "Number of pincode(s) found:1",
                "Status": "Success",
                "PostOffice": [
                    {"Name": "Koramangala VI Bk"}
                ]
            }
        ])
    else:
        return FakeResponse([])

class TestPinValidator(unittest.TestCase):

    @patch('pin_validator.requests.get', side_effect=fake_requests_get)
    def test_valid_address_1(self, mock_get):
        """Valid address with 'Mysore Bank Colony' and PIN 560050."""
        address = ("2nd Phase, 374/B, 80 Feet Rd, Mysore Bank Colony, "
                   "Banashankari 3rd Stage, Srinivasa Nagar, Bengaluru, Karnataka 560050")
        is_valid, message = validate_address(address)
        self.assertTrue(is_valid, msg=message)

    @patch('pin_validator.requests.get', side_effect=fake_requests_get)
    def test_valid_address_2(self, mock_get):
        """Valid address with 'Bank Colony' and PIN 560050."""
        address = ("2nd Phase, 374/B, 80 Feet Rd, Bank Colony, "
                   "Banashankari 3rd Stage, Srinivasa Nagar, Bengaluru, Karnataka 560050")
        is_valid, message = validate_address(address)
        self.assertTrue(is_valid, msg=message)

    @patch('pin_validator.requests.get', side_effect=fake_requests_get)
    def test_valid_address_3(self, mock_get):
        """Valid address with 'State Bank Colony' that should match 'State Bank Of Mysore Colony'."""
        address = ("374/B, 80 Feet Rd, State Bank Colony, "
                   "Banashankari 3rd Stage, Srinivasa Nagar, Bangalore. 560050")
        is_valid, message = validate_address(address)
        self.assertTrue(is_valid, msg=message)

    @patch('pin_validator.requests.get', side_effect=fake_requests_get)
    def test_invalid_address_wrong_pin(self, mock_get):
        """Invalid address: PIN 560095 returns a post office that does not match the address tokens."""
        address = ("2nd Phase, 374/B, 80 Feet Rd, Mysore Bank Colony, "
                   "Banashankari 3rd Stage, Srinivasa Nagar, Bengaluru, Karnataka 560095")
        is_valid, message = validate_address(address)
        self.assertFalse(is_valid, msg=message)

    @patch('pin_validator.requests.get', side_effect=fake_requests_get)
    def test_invalid_address_generic(self, mock_get):
        """Invalid address: Only a generic 'Colony' is provided along with PIN 560050."""
        address = "Colony, Bengaluru, Karnataka 560050"
        is_valid, message = validate_address(address)
        self.assertFalse(is_valid, msg=message)

if __name__ == "__main__":
    unittest.main()
