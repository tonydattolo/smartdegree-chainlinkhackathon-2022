// SPDX-License-Identifier: MIT


// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721URIStorage.sol
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

pragma solidity >=0.8.7 <0.9.0;
contract SmartDegree is ERC721, ERC721URIStorage {
    
    address multiversityOracle;
    address student;
    mapping (address => bool) courseInstructors;

    string[] IpfsUri = [
        
    ]

    constructor() {
        multiversityOracle = address(0xcEd9bCf41deff4098c8588B92Bce56a650230500);
        student = msg.sender;
    }


    // course struct
    struct Course {
        address instructor;
        string courseCode;
        string courseName;
    }

    Course[] public coursesTaken;
    mapping (address => Course) public coursesTakenMap;

    modifier isApprovedCourseVerifier() {
        // check if the msg.sender is in the courseInstructors mapping or is multiversityOracle
        require(
            courseInstructors[msg.sender] || msg.sender == multiversityOracle,
            "Only course instructors or multiversityOracle can approve a course"
        );
        _;
    }

    // public function that gets an array of courses taken by a student
    function getCoursesCompleted() external view returns (Course[] memory) {
        return coursesTaken;
    }

    // function that adds a course to the coursesTaken array
    function addCourseCompleted(address instructor, string memory courseCode, string memory courseName) public isApprovedCourseVerifier {
        Course memory course = Course(instructor, courseCode, courseName);
        coursesTaken.push(course);
        coursesTakenMap[student] = course;
    }




}
