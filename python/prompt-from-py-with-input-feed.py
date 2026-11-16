import requests
import json

with open("input-llm-notes.txt") as f:
    data = f.read()

print(data)

res = requests.post(
        "http://127.0.0.1:11434/api/generate",
        json={
            "model": "llama3.2",
            "prompt": "what is the latest Oracle linux?",
            "stream": False,
            },
        )
data = res.json()
#print(res.text)
print(data["response"])
