FROM lambci/lambda:build-nodejs12.x

RUN mkdir /var/task/nodejs
WORKDIR /var/task/nodejs
COPY . .
RUN npm install
WORKDIR /var/task
RUN zip -r9 -q /var/task/layer.zip .

CMD ["/bin/bash"]
