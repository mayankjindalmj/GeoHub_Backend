// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
pragma abicoder v2;

// manages creation, deletion and updation of datasets.
contract DatasetManager {
  struct Dataset {
    string root; // unique id for this dataset. (same as ipns name)
    string name; // name of dataset.
    string dateCreated; // date and time of creation.
    string[] tags; // tags for this dataset.
    address creator; // creator of dataset.
    string dataKey; // data key.
    string dataIV; // data initialization vector.
    string ipnsPublishKey; // ipns publish key.
  }

  struct ReadKey {
    string root; // for storing keys corresponding to a dataset.
    bytes key;
    bytes iv;
  }

  struct WriteKey {
    string root;
    bytes publishKey; // ipns publish key.
  }

  address private owner; // creator of contract.

  mapping (string => Dataset) private datasets; // all datasets.
  mapping (address => string[]) private userDatasets; // from user address to dataset array.
  mapping (address => string) private ipfsAPIKeys; // from user address to ipfs api key.

  mapping (address => ReadKey[]) private sharedReadKeys; // read keys (key and iv pair).
  mapping (address => WriteKey[]) private sharedWriteKeys; // name publish key.

  constructor() {
    owner = msg.sender;
  }

  function addIPFSKey(string memory key) public {
    ipfsAPIKeys[msg.sender] = key;
  }

  function getIPFSKey() public view returns(string memory) {
    return ipfsAPIKeys[msg.sender];
  }

  function getDatasets() public view returns(string[] memory) {
    return userDatasets[msg.sender];
  }

  function getDatasetCount() public view returns(uint256) {
    return userDatasets[msg.sender].length;
  }

  function getDatasetFromUID(string memory uid) public view returns(Dataset memory) {
    return datasets[uid];
  }

  function getSharedWriteDatasets() public view returns(WriteKey[] memory) {
    return sharedWriteKeys[msg.sender];
  }

  function getSharedReadDatasets() public view returns(ReadKey[] memory) {
    return sharedReadKeys[msg.sender];
  }

  function addDataset(
    string memory root,
    string memory name,
    string memory dateCreated,
    string[] memory tags,
    string memory dataKey,
    string memory dataIV,
    string memory ipnsPublishKey
    ) public returns(bool) {

    Dataset memory newDataset = Dataset(root, name, dateCreated, tags, msg.sender,
      dataKey, dataIV, ipnsPublishKey);

    datasets[root] = newDataset;
    userDatasets[msg.sender].push(root);

    return true;
  }

  // function addReadAccess(
  //   string memory uid,
  //   address user_addr,
  //   string memory data_read_key
  // ) public returns(bool) {
  //   // check if caller is the creator of dataset or not.
  //   string[] memory callerDatasets = userDatasets[msg.sender];
  //   bool callerIsOwner = false;
  //   for (uint256 index = 0; index < callerDatasets.length; index++) {
  //     if (keccak256(bytes(callerDatasets[index])) == keccak256(bytes(uid))) {
  //       callerIsOwner = true;
  //       break;
  //     }
  //   }

  //   if (!callerIsOwner) {
  //     return false;
  //   }

  //   Key memory newKey = Key(uid, data_read_key);
  //   sharedReadKeys[user_addr].push(newKey);
  //   return true;
  // }

  // function addWriteAccess(
  //   string memory uid,
  //   address user_addr,
  //   string memory data_write_key
  // ) public returns(bool) {
  //   // check if caller is the creator of dataset or not.
  //   string[] memory callerDatasets = userDatasets[msg.sender];
  //   bool callerIsOwner = false;
  //   for (uint256 index = 0; index < callerDatasets.length; index++) {
  //     if (keccak256(bytes(callerDatasets[index])) == keccak256(bytes(uid))) {
  //       callerIsOwner = true;
  //       break;
  //     }
  //   }

  //   if (!callerIsOwner) {
  //     return false;
  //   }

  //   Key memory newKey = Key(uid, data_write_key);
  //   sharedReadKeys[user_addr].push(newKey);
  //   return true;
  // }
  
  // function updateDataset(string memory uid, string memory new_metadata_hash) public returns(bool) {
  //   Key[] memory sharedWriteDatasets = sharedWriteKeys[msg.sender];
  //   bool callerIsWriter = false;
  //   for (uint256 index = 0; index < sharedWriteDatasets.length; index++) {
  //     if (keccak256(bytes(sharedWriteDatasets[index].uid)) == keccak256(bytes(uid))) {
  //       callerIsWriter = true;
  //       break;
  //     }
  //   }

  //   if (!callerIsWriter) {
  //     return false;
  //   }

  //   datasets[uid].metadata_hash = new_metadata_hash;
  //   return true;
  // }
}