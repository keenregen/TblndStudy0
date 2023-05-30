// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

import "@tableland/evm/contracts/utils/TablelandDeployments.sol";
import "@tableland/evm/contracts/utils/SQLHelpers.sol";
import "@tableland/evm/contracts/TablelandController.sol";
import "@tableland/evm/contracts/TablelandPolicy.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";

contract TblndZero is TablelandController, ERC721Holder {
    uint256 public tableId; // returned once the table is generated
    string private constant _TABLE_PREFIX = "evm_table"; // prefix for a table
    

    constructor() {
        // the method below gets the chain id then generate a table
        tableId = TablelandDeployments.get().create(
            address(this), // the address to mint the table to [this smart contract for this case]
            // the code below is to generate
            SQLHelpers.toCreateFromSchema( 
                "id integer primary key," // id, type integer [as primary key]
                "val text", // val as text
                _TABLE_PREFIX
            )
        );

        // change the data in the table
        TablelandDeployments.get().mutate(
            address(this), // this contract is calling the method
            tableId,
            SQLHelpers.toInsert(
                _TABLE_PREFIX,
                tableId,
                "id,val",
                string.concat(
                    "1",
                    ",",
                    SQLHelpers.quote("New Tables")
                )
            )
        );
        }

        function tableName() external view returns (string memory) {
            return SQLHelpers.toNameFromId(_TABLE_PREFIX,tableId);
        }

        function setController() public {
            TablelandDeployments.get().setController(
                address(this), // caller
                tableId,
                address(this) // set the controller address
            );
        }

        function getPolicy (address, uint256) public payable override returns (TablelandPolicy memory) {
            // restrict updates to a single column
            string[] memory updatableColumns = new string[](1);
            updatableColumns[0] = "val";

            return
            TablelandPolicy({
                allowInsert: true,
                allowUpdate: true,
                allowDelete: false,
                whereClause: "id > 1",
                withCheck: "",
                updatableColumns: updatableColumns
            });

        }   
}
