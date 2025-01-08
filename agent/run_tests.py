import requests
import json
import datetime

HOST = "http://127.0.0.1:8000"

try:
    response = requests.get(
        url=f"{HOST}/api/v1/config",
        params={
            "timestamp": datetime.datetime.now().isoformat(),
            "account_id": "1234567890",
        },
        headers={
            'Authorization': f'Bearer 1234567890',
            'Content-Type': 'application/json',
            'Accept': 'application/json'
        },
        timeout=10
    )
    
    if response.status_code == 200:
        print("Success!")
        print(json.dumps(response.json(), indent=2))
    else:
        print(f"Error: {response.status_code}")
        print(f"Response: {response.text}")
        
except requests.exceptions.RequestException as e:
    print(f"Request failed: {e}")
