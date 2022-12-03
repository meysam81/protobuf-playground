PROTOS := $(shell find proto -name '*.proto')
GOLANG_FILES := $(shell find . -name '*.go')
PWD := $(shell pwd)
PYTHONPATH := $(PWD)/server/python/:$(PWD)/server/python/proto_files:$(PWD)/client/python/:$(PWD)/client/python/proto_files
export PYTHONPATH

protoc-go:
	protoc \
		--go_out=./server/golang/proto \
		--go_out=./client/golang/proto \
		--go-grpc_out=./server/golang/proto \
		--go-grpc_out=./client/golang/proto \
		$(PROTOS)

protoc-python:
	python -m grpc_tools.protoc \
		--proto_path=./proto \
		--python_out=./server/python/proto_files \
		--pyi_out=./server/python/proto_files \
		--grpc_python_out=./server/python/proto_files \
		--python_out=./client/python/proto_files \
		--pyi_out=./client/python/proto_files \
		--grpc_python_out=./client/python/proto_files \
		$(PROTOS)

run-server-python:
	watchmedo auto-restart -d $(PWD) -p "*.py" -R -- python ./server/python/main.py

run-server-golang:
	cd ./server/golang && go run app/main.go

run-client-python:
	python ./client/python/main.py

run-client-golang:
	cd ./client/golang/ && go run ./app/main.go

install-requirements-python-client:
	pip install -r ./client/python/requirements.txt

install-requirements-python-server:
	pip install -r ./server/python/requirements.txt

install-requirements-python: install-requirements-python-server install-requirements-python-client

install-requirements-golang-client:
	cd ./client/golang && go mod tidy

install-requirements-golang-server:
	cd ./server/golang && go mod tidy

install-requirements-golang: install-requirements-golang-server install-requirements-golang-client

lint-python:
	pre-commit run -a

lint-golang-client:
	cd ./client/golang && golangci-lint run

lint-golang-server:
	cd ./server/golang && golangci-lint run

lint-golang: lint-golang-client lint-golang-server