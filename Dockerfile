# Use Node.js 16 base image for building the app
FROM node:16 AS build

# Set the working directory
WORKDIR /app

# Copy the package.json and yarn.lock files
COPY package.json yarn.lock ./

# Install dependencies
RUN yarn install

# Copy the entire project (adjust the path if Dockerfile is within apps/view)
COPY . .

# Change directory to the view app
WORKDIR /app/apps/view

# Build the @tracespace/view app
RUN yarn build

# Use a lightweight server to serve the built app
FROM node:16-alpine

# Install http-server globally
RUN npm install -g http-server

# Set working directory
WORKDIR /app

# Copy the built files from the build stage
COPY --from=build /app/apps/view/dist ./

# Expose the port the app will run on
EXPOSE 8080

# Command to start the server
CMD ["http-server", "-p", "8080"]
