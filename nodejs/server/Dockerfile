FROM node:latest

WORKDIR /usr/src/app

COPY nodejs/server/package.json ./

RUN npm install

COPY nodejs/server ./

EXPOSE 5000

CMD ["node", "app.js"]