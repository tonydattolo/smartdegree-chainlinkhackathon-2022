// SPDX-License-Identifier: MIT


// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721URIStorage.sol
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@chainlink/contracts/src/v0.8/KeeperCompatible.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

pragma solidity >=0.8.7 <0.9.0;
contract SmartDegree is ERC721, ERC721URIStorage, KeeperCompatibleInterface, AccessControl {
    
    address immutable MUTLIVERSITY_ORACLE;
    address immutable STUDENT_ADDRESS;
    mapping (address => bool) courseInstructors;

    event GrantRole(bytes32 indexed role, address indexed account);
    event RevokeRole(bytes32 indexed role, address indexed account);
    mapping(bytes32 => mapping(address => bool)) public roles;

    bytes32 private constant MULTIVERSITIY_ADMIN_ROLE = keccak256(abi.encodePacked("ADMIN"));
    bytes32 private constant STUDENT_ROLE = keccak256(abi.encodePacked("STUDENT_ROLE"));
    bytes32 private constant INSTRUCTOR_ROLE = keccak256(abi.encodePacked("INSTRUCTOR_ROLE"));

    uint256 public tokenCounter;

    string[] IpfsUri = [
        "https://ipfs.io/ipfs/Qmcy7BzwKducdyzGvcKfQQiY1bHoqTeXXoQSh7Yt7xjkJD",
        "https://ipfs.io/ipfs/QmdwTtHcDLNP43VkjeZxKeakgokMaiwpxUeBbWgr22V6ZS"
    ];

    uint currentDegreeUpdateState;
    uint lastDegreeUpdateState;
    uint lastDegreeUpdateStateTimestamp;

    constructor() public ERC721("SmartDegree", "SDMV") {
        MUTLIVERSITY_ORACLE = address(0xcEd9bCf41deff4098c8588B92Bce56a650230500);
        STUDENT_ADDRESS = msg.sender;
        currentDegreeUpdateState = 0;
        lastDegreeUpdateState = 0;
        lastDegreeUpdateStateTimestamp = 0;
        tokenCounter = 0;

        _setupRole(STUDENT_ROLE, STUDENT_ADDRESS);
        _setupRole(MULTIVERSITIY_ADMIN_ROLE, MUTLIVERSITY_ORACLE);
    }

    function createSmartDegree(string memory tokenURI) public onlyRole(STUDENT_ROLE) returns (uint256) {
        uint256 newTokenId = tokenCounter;
        _safeMint(msg.sender, newTokenId);
        _setTokenURI(newTokenId, tokenURI);
        // tokenCounter = tokenCounter + 1;
        return newTokenId;
    }

    modifier onlyRole(bytes32 _role) override {
        require(roles[_role][msg.sender], "not authorized");
        _;
    }

    function _grantRole(bytes32 _role, address _account) internal {
        roles[_role][_account] = true;
        emit GrantRole(_role, _account);
    }

    function grantRole(bytes32 role, address account) public onlyRole(MULTIVERSITIY_ADMIN_ROLE) {
        _grantRole(role, account);
    }

    function _revokeRole(bytes32 _role, address _account) internal {
        roles[_role][_account] = false;
        emit RevokeRole(_role, _account);
    }

    function revokeRole(bytes32 role, address account) public onlyRole(MULTIVERSITIY_ADMIN_ROLE) {
        _revokeRole(role, account);
    }

    
    // function that lists all accounts with a role
    // function getAccountsWithRole(bytes32 _role) public view returns (address[] memory) {
    //     address[] memory result;
    //     for (uint256 index = 0; index < roles.length; index++) {
    //         if (roles[_role][index]) {
    //             result.push(index);
    //         }
    //     }
    //     return result;
    // }

    // course struct
    struct Course {
        address instructor;
        string courseCode;
        string courseName;
    }

    Course[] public coursesTaken;
    mapping (address => Course) public coursesTakenMap;

    // modifier isApprovedCourseVerifier() {
    //     // check if the msg.sender is in the courseInstructors mapping or is multiversityOracle
    //     require(
    //         courseInstructors[msg.sender] || msg.sender == MUTLIVERSITY_ORACLE,
    //         "Only course instructors or multiversityOracle can approve a course"
    //     );
    //     _;
    // }

    // public function that gets an array of courses taken by a student
    function getCoursesCompleted() external view returns (Course[] memory) {
        return coursesTaken;
    }

    // function that adds a course to the coursesTaken array
    // function addCourseCompleted(address instructor, string memory courseCode, string memory courseName) public isApprovedCourseVerifier {
    function addCourseCompleted(address instructor, string calldata courseCode, string calldata courseName) public 
        onlyRole(INSTRUCTOR_ROLE) {
            require(instructor == msg.sender, "Only the instructor can verify a student completed a course");
            Course memory course = Course(instructor, courseCode, courseName);
            coursesTaken.push(course);
            currentDegreeUpdateState = currentDegreeUpdateState + 1;
            renounceRole(INSTRUCTOR_ROLE, instructor);
            
    }

    function getCurrentDegreeState() public view returns (uint) {
        return currentDegreeUpdateState;
    }

    function updateDegree(uint256 _tokenId) public {
        if(currentDegreeUpdateState > tokenCounter) {
            currentDegreeUpdateState = currentDegreeUpdateState + 1;
            _setTokenURI(currentDegreeUpdateState, IpfsUri[currentDegreeUpdateState]);
        }
    }

    function checkUpkeep(bytes calldata /* checkData */) external view override returns (bool upkeepNeeded, bytes memory /* performData */) {
        upkeepNeeded = currentDegreeUpdateState > tokenCounter;
        // We don't use the checkData in this example. The checkData is defined when the Upkeep was registered.
    }

    function performUpkeep(bytes calldata /* performData */) external override {
        //We highly recommend revalidating the upkeep in the performUpkeep function
        if (currentDegreeUpdateState > tokenCounter) {
            lastDegreeUpdateStateTimestamp = block.timestamp;
            updateDegree(tokenCounter);
        }
    }


}
