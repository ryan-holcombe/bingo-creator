FROM node:16.13.1-alpine AS builder
WORKDIR /app
COPY . .
RUN yarn install && yarn build

FROM nginx:alpine
COPY nginx/default.conf.template /etc/nginx/conf.d/default.conf.template

COPY --from=builder /app/build /usr/share/nginx/html

ENV PORT 8080
ENV HOST 0.0.0.0
EXPOSE 8080
CMD /bin/sh -c "envsubst '\$PORT' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"
