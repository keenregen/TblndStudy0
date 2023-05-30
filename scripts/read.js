const hre = require("hardhat");
const {Database, Validator, helpers} = require("@tableland/sdk");

async function main() {

    const contractAddr = "0x1cFfe856cCe8D024528895Be3E00F29da3118bf5";
    const tblndZero = await hre.ethers.getContractAt("TblndZero", contractAddr);
    const tableId = await tblndZero.tableId();
    console.log("TableId: ", tableId.toString());
    const tableName = await tblndZero.tableName();
    console.log("Table Name: ", tableName);
    const db = new Database ();
    const { results } = await db.prepare(`SELECT * FROM ${tableName};`).all();
    console.log(results);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});