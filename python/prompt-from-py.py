import requests
import json

res = requests.post(
        "http://127.0.0.1:11434/api/generate",
        json={
            "model": "llama3.2",
            "prompt": "what is the latest Oracle linux and release year with kernel?",
            "stream": False,
            },
        )
data = res.json()
#print(res.text)
print(data["response"])
