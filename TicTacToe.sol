pragma solidity >=0.7.0 <0.9.0;

contract TicTacToe {
    address public player1;
    address public player2;

    uint[3][3] public state;

    uint public stepNumber = 0; 
    uint public lastStepTimeStamp = 0;

    function deposit() public payable {
        require(msg.value == 0.5 ether, "You can only send 0.5 Ether");

        if (player1 == address(0)) {
            player1 = msg.sender;
        } else {
            if (player2 == address(0)) {
                player2 = msg.sender;
            }
        }
    }

    function makeStep(uint _x, uint _y) public {
        if (stepNumber % 2 == 0 && player1 == msg.sender) {
            if (state[_x][_y] == 0) {
                state[_x][_y] = 1;
            }
            stepNumber += 1;
        } else if (stepNumber % 2 == 1 && player2 == msg.sender) {
            if (state[_x][_y] == 0) {
                state[_x][_y] = 2;
            }
            stepNumber += 1;
        }
    }

    function check() public {
        //Если еще не делали шаги, то проверять нет смысла.
        if (stepNumber != 0) {
            //Если один из играков не делает шаг 6 часов, то отдаем награду второму.
            if (block.timestamp > lastStepTimeStamp + 6 hours) {
                if (stepNumber % 2 == 1) {
                    player1.call{value: address(this).balance};
                } else {
                    player2.call{value: address(this).balance};
                }
            }

            bool isPlayer1Win = isPlayerWin(1);
            bool isPlayer2Win = isPlayerWin(2);

            bool send = false;
            if (isPlayer1Win && isPlayer2Win) {
                (bool send1, ) = player1.call{value: address(this).balance / 2}("");
                (bool send2, ) = player2.call{value: address(this).balance / 2}("");
                send = send1 && send2;
            } else if (isPlayer1Win) {
                (send,) = player1.call{value: address(this).balance}("");
            } else if (isPlayer2Win) {
                (send,) = player2.call{value: address(this).balance}("");
            }
            require(send, "Failed to send Ether");
        }

    }

    function isPlayerWin(uint _playerNumber) private view returns (bool) {
        //Проверяем все вертикали
        for (uint i = 0; i < 3; i++) {
            if (state[i][0] == _playerNumber && state[i][1] == _playerNumber && state[i][2] == _playerNumber) {
                return true;
            }
        }
        //Проверяем все горизонтали
        for (uint i = 0; i < 3; i++) {
            if (state[0][i] == _playerNumber && state[1][i] == _playerNumber && state[2][i] == _playerNumber) {
                return true;
            }
        }
        
        //Проверяем диагонали
        if (state[0][0] == _playerNumber && state[1][1] == _playerNumber && state[2][2] == _playerNumber) {
            return true;
        }
        if (state[0][2] == _playerNumber && state[1][1] == _playerNumber && state[2][0] == _playerNumber) {
            return true;
        }

        return false;
    }
}
