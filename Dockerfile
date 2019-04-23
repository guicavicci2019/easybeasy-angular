#builder
FROM node:8 as builder

ARG PROJ

WORKDIR /usr/src/app
ADD . /usr/src/app

RUN rm -f ./package-lock.json
RUN npm set progress=false
RUN npm install
RUN npm rebuild node-sass

RUN ./node_modules/@angular/cli/bin/ng build mm-ui

RUN npm run build

#runner
FROM nginx:1.13.3-alpine

EXPOSE 80

ARG PROJ

COPY config.nginx /etc/nginx/conf.d/default.conf

RUN rm -rf /usr/share/nginx/html/*

## From 'builder' stage copy over the artifacts in dist folder to default nginx public folder
COPY --from=builder /usr/src/app/dist/$PROJ /usr/share/nginx/html

WORKDIR /usr/share/nginx/html

CMD ["nginx", "-g", "daemon off;"]

