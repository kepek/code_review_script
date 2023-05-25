import openai
import sys
import os
import re
from datetime import datetime

# Get API key from environment variables
OPENAI_API_KEY = os.getenv('OPENAI_API_KEY')

openai.api_key = OPENAI_API_KEY

# Get the path of the temporary file from the command line argument
temp_file_path = sys.argv[1]

# Read the diff from the temporary file
with open(temp_file_path, 'r') as file:
    code_diff = file.read()

print(f"Sending the following diff for review:\n{code_diff}\n")

# Extract the filename from the diff using a regular expression
match = re.search(r'diff --git a/(.*) b/(.*)', code_diff)
filename = match.group(1) if match else 'Unknown file'

# Replace any special characters in the filename with underscores
filename = re.sub(r'\W', '_', filename)

response = openai.Completion.create(
  engine="text-davinci-003",  # update to "text-davinci-004" if GPT-4 becomes available
  # how to use gpt-4?
  # https://beta.openai.com/docs/guides/gpt3-migration

  prompt=f"Bellow is the code patch, please help me do a brief code review in my Angular/TypeScript project. If any "
         f"bug risk and improvement suggestion are welcome :\n```diff\n{code_diff}\n```",
  temperature=0.5,
  max_tokens=150
)

review_comment = response.choices[0].text.strip()

print("Review comment received.")

# Get the current date to use in the filename
current_date = datetime.now().strftime('%Y-%m-%d')

# Create a Markdown file in the current directory with the filename and date
with open(f'code_review_{current_date}_{filename}.md', 'a') as file:  # note the 'a' flag to append to the file
    file.write(f'## Review for file: {filename}\n')
    file.write(review_comment)
    file.write('\n\n')  # add some spacing between reviews

print(f"Review comment written to code_review_{current_date}_{filename}.md")

# Remove the diff file
os.remove(temp_file_path)
print(f"Diff file {temp_file_path} removed.")
