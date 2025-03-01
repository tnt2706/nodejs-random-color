# Use an official Node.js runtime as the base image
FROM node:14

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install the application dependencies
RUN npm install

# Copy the application code to the working directory
COPY . .

# Expose the port on which the application will run
EXPOSE 3000

# Start the application
CMD [ "npm", "start" ]# Stage 1: Build
FROM node:14-alpine AS builder

WORKDIR /app

# Copy package files and install only production dependencies
COPY package*.json ./
RUN npm install --production && npm cache clean --force

# Copy the rest of the application
COPY . .

# Stage 2: Run
FROM node:14-alpine

WORKDIR /app

# Copy built application from builder stage
COPY --from=builder /app ./

# Ensure node_modules has correct permissions
RUN chown -R node:node /app

USER node

EXPOSE 3000

CMD ["npm", "start"]

