FROM node:8.12.0-alpine

LABEL maintainer="Tiago M Reichert <tiago@reichert.eti.br>"

WORKDIR /usr/src/app
COPY package.json ./
RUN npm install --only=production

COPY server.js ./

EXPOSE 3000

CMD [ "npm", "start" ]
