const fs = require('fs');
const solc = require('solc');
const Web3 = require('web3');
const BigNumber = require('bignumber.js');

const option = {
    gasLimit: 4700000,
    gasPrice: '20000000000'
};


const teamShare = new BigNumber('300000000');
const exa = new BigNumber('1000000000000000000');
const cap = new BigNumber('1000000000');
const rate1 = 75000;
const cap1 = 2000;
const start1 = 1517850000;
const end1 = 1520265600;

const logStream = fs.createWriteStream("x.txt");
// Connect to local Ethereum node
const web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
const mainAccount = web3.eth.accounts[3];
const wallet = web3.eth.accounts[4];
web3.eth.defaultAccount = mainAccount;
log("Main account is " + mainAccount);
log("Wallet set to  " + wallet);

function log(message) {
    console.log(message);
    logStream.write(message + '\n');
}

function compileContract(contractName) {
    return new Promise((resolve, reject) => {
        const input = fs.readFileSync('contracts/' + contractName + '.sol');
        const output = solc.compile(input.toString(), 1);
        const bytecode = output.contracts[':' + contractName].bytecode;
        const abi = JSON.parse(output.contracts[':' + contractName].interface);
        console.log(contractName + ' compiled successfully');
        resolve({
            bytecode: bytecode,
            abi: abi,
            name: contractName
        });
    });
}

function deployContract(contract, consructorParam) {
    return new Promise((resolve, reject) => {
        const transactionOption = { data: '0x' + contract.bytecode, from: mainAccount, gas: option.gasLimit, gasPrice: option.gasPrice };
        const callback = function (err, res) {
            if (err) {
                log(err);
                reject();
            }

            if (res.address) {
                log(contract.name + ' address: ' + res.address);
                resolve(res);
            }
        };
        let args = [];
        args = args.concat(consructorParam)
        args.push(transactionOption)
        args.push(callback);
        let factory = web3.eth.contract(contract.abi);
        factory.new.apply(factory, args);
    });
}
Promise.all([compileContract('CommunityCoin'), compileContract('TokenLocker'), compileContract('CTCSale')]).then(function (values) {
    const CommunityCoin = values[0];
    const TokenLocker = values[1];
    const CTCSale = values[2];

    const compiled = {
        token: CommunityCoin,
        locker: TokenLocker,
        sale: CTCSale
    }

    fs.writeFileSync('compiled.json', JSON.stringify(compiled));

    deployContract(CommunityCoin, [start1, cap]).then(token => {
        Promise.all(
            [deployContract(TokenLocker, [token.address]),
            deployContract(CTCSale, [start1, end1, rate1, cap1, wallet, token.address]),]
        ).then(values => {
            const locker = values[0];
            const tier1 = values[1];

            const deployed = {
                token: token.address,
                locker: locker.address,
                tier1: tier1.address
            };

            fs.writeFileSync('deployed.json', JSON.stringify(deployed));

            token.mint(deployed.locker, teamShare.times(exa), (err, res) => {
                if (err) {
                    console.log(err);
                }
                locker.deposite();
                token.transferOwnership(tier1.address,(err, res)=>{
                    if(err) {
                        console.log(err);
                    }
                    console.log(res);
                });
            });
        }).catch(error => {
            log(error);
        });


    });

}).catch(error => {
    log(error);
});

function getNow() {
    return Math.round(new Date().getTime() / 1000.0);
}

function getDay(day) {
    return day * 24 * 60 * 60;
}

logStream.close();