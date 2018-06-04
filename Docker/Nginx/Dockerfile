FROM nginx:alpine
MAINTAINER Gary Wallis "docker@unxs.io"

#FreeRadius
COPY ./nginx.conf /etc/nginx/nginx.conf

#test local dev
#	docker build -t nginxfr:dev .
#private repo version:
#	docker build -t docker0.unxs.io:5000/nginxfr:dev .
#	docker push docker0.unxs.io:5000/nginxfr:dev
