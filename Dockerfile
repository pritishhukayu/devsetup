# Use an official Node.js runtime as a parent image for building the Node.js server
FROM node:14 AS node-builder

# Set the working directory in the container for building the Node.js server
WORKDIR /usr/src/node-app

# Copy package.json and package-lock.json to the working directory
COPY node-app/package*.json ./

# Install dependencies for the Node.js server
RUN npm install

# Copy the rest of the application code for the Node.js server
COPY node-app/ .

# Build the Node.js server
RUN npm run build

# Use an official Python runtime as a parent image for building the Python Flask app
FROM python:3.9 AS python-builder

# Set the working directory in the container for building the Python Flask app
WORKDIR /usr/src/flask-app

# Copy the requirements file to the working directory
COPY flask-app/requirements.txt ./

# Install Flask and other dependencies for the Python Flask app
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code for the Python Flask app
COPY flask-app/ .

# Expose ports for both the Node.js server and the Python Flask app
EXPOSE 3000
EXPOSE 5000

# Use a final base image for running the applications
FROM node:14

# Set the working directory for the final image
WORKDIR /usr/src/app

# Copy built Node.js server from node-builder stage
COPY --from=node-builder /usr/src/node-app/dist ./node-app

# Copy built Python Flask app from python-builder stage
COPY --from=python-builder /usr/src/flask-app ./

# Define the command to run both applications
CMD ["npm", "run", "start"]
