import os

# Get all environment variables as a dictionary
env_vars = os.environ

# Print each variable
for key, value in env_vars.items():
    print(f"{key}")
    