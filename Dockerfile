# Use an official Node.js runtime as a parent image for building the Node.js server
FROM node:14 AS node-builder

# Set the working directory in the container for building the Node.js server
WORKDIR /usr/src/node-app

# Copy the application code for the Node.js server
COPY node-app/ .

# Build the Node.js server
RUN npm run build

# Use an official Python runtime as a parent image for building the Python Flask app
FROM python:3.9 AS python-builder

# Set the working directory in the container for building the Python Flask app
WORKDIR /usr/src/flask-app

# Copy the application code for the Python Flask app
COPY flask-app/ .

# Use a final base image for running the applications
FROM node:14

# Set the working directory for the final image
WORKDIR /usr/src/app

# Copy built Node.js server from node-builder stage
COPY --from=node-builder /usr/src/node-app/dist ./node-app

# Copy Python Flask app from python-builder stage
COPY --from=python-builder /usr/src/flask-app ./

# Expose ports for both the Node.js server and the Python Flask app
EXPOSE 3000
EXPOSE 5000

# Define the command to run both applications
CMD ["npm", "run", "start"]
