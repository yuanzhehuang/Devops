# Use node:14 as a base image
FROM node:latest

# Create app directory (use /app path)
WORKDIR /app

# Copy all package json files under /app
COPY package*.json ./

# Run yarn install
RUN yarn install

# copy all files into the image
COPY . .

# open required port number
EXPOSE 3000

# run application
CMD ["yarn", "run", "start"]