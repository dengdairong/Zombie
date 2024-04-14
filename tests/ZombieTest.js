// // 引入Web3模块
// const Web3 = require('web3');
 
// // Remix VM的HTTP服务地址通常是http://localhost:8545
// const provider = new Web3.providers.HttpProvider('http://localhost:8545');
 
// // 创建web3实例
// const web3 = new Web3(provider);

// 下面是调用合约的方式:
var abi = [
		{
			"anonymous": false,
			"inputs": [
				{
					"indexed": false,
					"internalType": "uint256",
					"name": "zombieId",
					"type": "uint256"
				},
				{
					"indexed": false,
					"internalType": "string",
					"name": "name",
					"type": "string"
				},
				{
					"indexed": false,
					"internalType": "uint256",
					"name": "dna",
					"type": "uint256"
				}
			],
			"name": "NewZombie",
			"type": "event"
		},
		{
			"inputs": [
				{
					"internalType": "string",
					"name": "_name",
					"type": "string"
				}
			],
			"name": "createRandomZombie",
			"outputs": [],
			"stateMutability": "nonpayable",
			"type": "function"
		},
		{
			"inputs": [
				{
					"internalType": "uint256",
					"name": "",
					"type": "uint256"
				}
			],
			"name": "zombies",
			"outputs": [
				{
					"internalType": "string",
					"name": "name",
					"type": "string"
				},
				{
					"internalType": "uint256",
					"name": "dna",
					"type": "uint256"
				}
			],
			"stateMutability": "view",
			"type": "function"
		}
	]
var contractAddress = "0xf8e81D47203A594245E36C48e151709F0C19fBe8"
var ZombieFactory = new web3.eth.Contract(abi,contractAddress)




// 监听 `NewZombie` 事件, 并且更新UI
var event = ZombieFactory.events.NewZombie(function(error, result) {
    console.log(result)
  if (error) {
    console.log(error+"1111")
    console.log("1111")
    return
  }
  console.log("test1")
  var json = generateZombie(result.zombieId, result.name, result.dna)
  web3.eth.log(JSON.stringify(json))
})

// 获取 Zombie 的 dna, 更新图像
function generateZombie(id, name, dna) {
  let dnaStr = String(dna)
  // 如果dna少于16位,在它前面用0补上
  while (dnaStr.length < 16)
    dnaStr = "0" + dnaStr

  let zombieDetails = {
    // 前两位数构成头部.我们可能有7种头部, 所以 % 7
    // 得到的数在0-6,再加上1,数的范围变成1-7
    // 通过这样计算：
    headChoice: dnaStr.substring(0, 2) % 7 + 1，
    // 我们得到的图片名称从head1.png 到 head7.png

    // 接下来的两位数构成眼睛, 眼睛变化就对11取模:
    eyeChoice: dnaStr.substring(2, 4) % 11 + 1,
    // 再接下来的两位数构成衣服，衣服变化就对6取模:
    shirtChoice: dnaStr.substring(4, 6) % 6 + 1,
    //最后6位控制颜色. 用css选择器: hue-rotate来更新
    // 360度:
    skinColorChoice: parseInt(dnaStr.substring(6, 8) / 100 * 360),
    eyeColorChoice: parseInt(dnaStr.substring(8, 10) / 100 * 360),
    clothesColorChoice: parseInt(dnaStr.substring(10, 12) / 100 * 360),
    zombieName: name,
    zombieDescription: "A Level 1 CryptoZombie",
  }
  return zombieDetails
}


console.log("test")
ZombieFactory.methods.createRandomZombie("ddr")