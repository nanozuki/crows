From alpine:latest

RUN apk add -U vim

ENTRYPOINT ["vim --version"]
