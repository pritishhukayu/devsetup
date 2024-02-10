# Use an official Node.js runtime as a parent image for running the Node.js server
FROM node:12.22.9 AS node-builder

# Set the working directory in the container for the Node.js server
WORKDIR /usr/src/node-app

# Copy the Node.js application code
COPY . .

# Use an official Python runtime as a parent image for running the Python Flask app
FROM python:3.10.12 AS python-builder

# Set the working directory in the container for the Python Flask app
WORKDIR /usr/src/flask-app

# Copy the Python Flask application code
COPY . .

# Use a final base image for running the applications
FROM node:12.22.9

# Set the working directory for the final image
WORKDIR /usr/src/app

# Copy the Node.js server from the node-builder stage
COPY --from=node-builder /usr/src/node-app .

# Copy the Python Flask app from the python-builder stage
COPY --from=python-builder /usr/src/flask-app .

# Expose ports for both the Node.js server and the Python Flask app
EXPOSE 3000
EXPOSE 5000

# Define the command to run both applications
CMD ["npm", "run", "start"]
