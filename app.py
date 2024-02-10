# File: app.py

# Importing required modules
from flask import Flask

# Create a Flask application instance
app = Flask(__name__)

# Define a route for the root URL
@app.route('/')
def hello():
    return 'Hello, world!'

# Run the application
if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
