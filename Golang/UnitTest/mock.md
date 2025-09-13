mockgen "-source=./app/login/login_interface.go" "-destination=./mocks/mock_login.go" "-package=mocks"

mockgen "-source=./app/roll_call/roll_call_interface.go" "-destination=./mocks/mock_roll_call.go" "-package=mocks"

