import requests
import datetime

USERNAME = "b4haa7"
response = requests.get(
    f"https://codeforces.com/api/user.status?handle={USERNAME}")
data = response.json()

solved = set()
streak = 0
today = datetime.date.today()

if data['status'] == 'OK':
    for submission in data['result']:
        if submission['verdict'] == 'OK':
            solved.add(submission['problem']['name'])
            if datetime.date.fromtimestamp(submission['creationTimeSeconds']) == today:
                streak += 1

print(f" {len(solved)}, 󰈸 {streak}")
