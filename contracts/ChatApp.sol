// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

contract ChatApp{

    // User Struct
    struct user{
        string name;
        friend[] friendList;
    }

    // Friend Struct
    struct friend{
        address pubkey;
        string name;
    }

    // Message Struct
    struct message{
        address sender;
        uint256 timestamp;
        string msg;
    }

    mapping(address => user) userList;
    mapping(bytes32 => message[]) allMessages;

    //Check User Exist
    function checkUserExist(address pubkey) public view returns(bool) {
        return bytes(userList[pubkey].name).length > 0;
    }

    //Create account
    function createAccount(string calldata name) external {
        require(checkUserExist(msg.sender) == false, "User already exists");
        require(bytes(name).length > 0, "Username cannot be empty");

        userList[msg.sender].name = name;
    }

    //Get username
    function getUsername(address pubkey) external view returns(string memory) {
        require(checkUserExist(pubkey) == false, "User is not registered");
        return userList[pubkey].name;
    }

    //Add Friend
    function addFriend(address friend_key, string calldata name) external {
        require(checkUserExist(msg.sender) == false, "Create an account first");
        require(checkUserExist(friend_key) == false, "User not registered");
        require(msg.sender != friend_key, "Users cannot add themselves as friend");
        require(checkAlreadyFriends(msg.sender, friend_key) == false, "These users are already friends");

        _addFriend(msg.sender, friend_key, name);
        _addFriend(friend_key, msg.sender, userList[msg.sender].name);
    }

    //Check Already Friends
    function checkAlreadyFriends(address pubkey1, address pubkey2) internal view returns(bool) {
        
        if(userList[pubkey1].friendList.length > userList[pubkey2].friendList.length) {
            address tmp = pubkey1;
            pubkey1 = pubkey2;
            pubkey2 = tmp;
        }

        for(uint256 i = 0; i < userList[pubkey1].friendList.length; i++ ) {
            if(userList[pubkey1].friendList[i].pubkey = pubkey2) return true;
        }

        return false;
    }
}