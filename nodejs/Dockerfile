FROM node:8.12.0-alpine

LABEL maintainer="Tiago M Reichert <tiago@reichert.eti.br>"

RUN apk add curl && rm -rf /var/cache/apk/*

WORKDIR /usr/src/app
COPY package.json ./
RUN npm install --only=production
COPY server.js ./

EXPOSE 3000

HEALTHCHECK --interval=15s --timeout=5s --start-period=15s --retries=3 CMD curl --fail http://localhost:3000/ || exit 1

CMD [ "npm", "start" ]
