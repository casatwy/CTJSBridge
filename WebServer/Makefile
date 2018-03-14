run:
	if [ -f ./ctserver.run ]; then rm ./ctserver.run; fi;
	go build -gcflags "-N -l" -o ctserver.run ./main.go
	sudo ./ctserver.run
