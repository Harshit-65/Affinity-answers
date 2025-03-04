import re
import requests

def clean_text(text):
    """
    Cleans the input text by:
      - Removing content inside parentheses.
      - Removing punctuation.
      - Converting to lowercase and splitting into tokens.
    """
    # Removing text within parentheses (e.g., "(Bangalore)")
    text = re.sub(r'\([^)]*\)', '', text)
    # Cleaning up all the punctuation marks
    text = re.sub(r'[^\w\s]', '', text)
    return text.lower().split()

def extract_pincode(address):
    """
    Extracts the first 6-digit number found in the address.
    """
    match = re.search(r'\b(\d{6})\b', address)
    return match.group(1) if match else None

def token_match(api_token, address_tokens):
    """
    Returns True if the api_token is found as a substring in any token from address_tokens.
    This helps match cases like "katemanivali" inside "katemanivalikalyan".
    """
    for token in address_tokens:
        if api_token in token or token in api_token:
            return True
    return False

def validate_address(address):
    """
    Validates whether the free-flowing address matches the PIN code area.
    
    For each Post Office in the API response for the PIN code,
      - It gathers expected tokens from:
          * The post office Name.
      - It then checks (via substring matching) how many expected tokens appear
        in the cleaned address tokens.
      - If a sufficient number (at least half, with a minimum of 2 if more than one token is expected)
        are found, the address is considered valid.
    
    Returns a tuple: (is_valid (bool), message (str))
    """
    pin = extract_pincode(address)
    if not pin:
        return False, "No valid PIN code found in address."

    url = f"https://api.postalpincode.in/pincode/{pin}"
    try:
        response = requests.get(url)
        data = response.json()
    except Exception as e:
        return False, f"API error: {e}"
    
    if not data or data[0].get("Status") != "Success" or not data[0].get("PostOffice"):
        return False, "Invalid PIN code or API returned error."

    address_tokens = clean_text(address)
    
    for office in data[0]["PostOffice"]:
        # here we gather expected tokens from Name
        expected_tokens = set(clean_text(office.get("Name", "")))
        
        
        print(f"Checking Post Office: {office.get('Name')}")
        print(f"Expected Tokens: {expected_tokens}")
        print(f"Address Tokens: {address_tokens}")
        
        # See how many tokens from the post office name appear in the address
        match_count = 0
        for token in expected_tokens:
            if token_match(token, address_tokens):
                match_count += 1
        
        # Here's our scoring system : we need at least half the words to match
        # (minimum 2 matches if there are multiple words)
        if len(expected_tokens) > 1:
            required_matches = max(2, int(round(len(expected_tokens) * 0.5)))
        else:
            required_matches = 1
        
        print(f"Match count: {match_count} (required: {required_matches})")
        
        if match_count >= required_matches:
            return True, f"Address is valid. Found matching post office: '{office.get('Name')}'."
    
    return False, "No matching post office found in address."

if __name__ == "__main__":
    
    address = "Kolsewadi, Katemanivali,Kalyan East,421306"
    is_valid, message = validate_address(address)
    print(is_valid, message)
