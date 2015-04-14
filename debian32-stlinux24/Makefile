IMG=$(shell basename $(shell pwd))

all : ${IMG}.tag
${IMG}.tag: Dockerfile
	docker build -t ${IMG} .
	touch ${IMG}.tag
clean:
	rm -f ${IMG}.tag
