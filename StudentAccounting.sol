pragma solidity >=0.7.0 <0.9.0;

contract StudentAccounting {

    struct Student {
        string name;
        uint age;
    }

    struct StudentWithGroup {
        Student student;
        uint group;
    }

    StudentWithGroup[] public studentsWithGroup;

    function addStudent(string memory _name, uint _age) public {
        studentsWithGroup.push(StudentWithGroup(
            Student(_name, _age),
            (uint(keccak256(abi.encode(_name))) + _age) % 100 //считаем, что у нас 100 групп
        ));
    }
}
