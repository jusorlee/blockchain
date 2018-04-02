首先开发机上必须装好Node.js，再使用以下命令安装所需的工具：
```
$ npm install -g ethereumjs-testrpc truffle
```


1、建立项目
```
$ mkdir HelloWorld

$ cd HelloWorld

$ truffle init

<!--
得到如下结果
Downloading...
Unpacking...
Setting up...
Unbox successful. Sweet!

Commands:

  Compile:        truffle compile
  Migrate:        truffle migrate
  Test contracts: truffle test
-->

```
/contracts: 存放智能合约原始代码的地方，可以看到里面已经有个 sol 文件，<BR>
/migrations: 这是 Truffle 用来部署智能合约的功能，<BR>
/test: 测试智能合约的代码放在这里，支持 js 与 sol 测试。<BR>
truffle.js: Truffle 的设置文档。<br>
```
$ truffle compile
<!--
Compiling ./contracts/Migrations.sol...
Writing artifacts to ./build/contracts
-->
```
```
$ truffle migrate
<!--
Error: No network specified. Cannot determine current network.
....
-->

```
如果出现上面这个错误，需要配置truffle.js文件,在文件里添加代码：
```
networks:{
    development:{
      host:"localhost",
      port:8545,
      network_id:"*"   //匹配任何network id
    }
  }
```
启动testrpc
```
$ testrpc
```

再次执行命令：
```
$ truffle migrate --reset
<!--
Using network 'development'.

Running migration: 1_initial_migration.js
  Deploying Migrations...
  ... 0x67106b3580182c8e5b7aa325681befdffa4997d8b5a0c01728170be4be769423
  Migrations: 0xea9c8829bd9d925310e5351e8480fbf9be8ce32b
Saving successful migration to network...
  ... 0x96fb7ac1c8a7e53eb3b7cdb39dd66b029fb9742e2b40c529b5e7a68d04e755bd
Saving artifacts...
-->
```
在 contracts 文件夹下新建 HelloWorld.sol 文件，当然也可以直接在 HelloWorld 路径下面直接
执行 truffle create contract HelloWorld 命令来创建 HelloWorld.sol <br>
HelloWorld.sol 文件內容如下：

```
/*版本申明*/
pragma solidity ^0.4.4;

/*变量值会永久存储在合约的存储空间，
contract的作用，有点像是class.
*/
contract HelloWorld{
    /*函数和GOLANG的很像，只是golang返回的时候不要写returns*/
	function sayHello() returns(string){
        /*返回一个字符串*/
		return ("hello world");
	}
}
```
truffle 框架中提供了方便部署合约的脚本。打开 migrations/2_deploy_contracts.js 文件（脚
本使用 Javascript 编写），将内容修改如下

```
var HelloWorld = artifacts.require("./HelloWorld.sol");

module.exports = function(deployer) {
  deployer.deploy(HelloWorld);
};
```

然后编译和部署：
```
truffle compile
truffle migrate --reset
```
==========================================<br>
与合约互动

```
$ truffle console

<!--truffle(development)> -->

```
下面这样子的，可以获取一个对象实例contract

```
HelloWorld.deployed().then(instance => contract = instance)
```
然后可以来调用实例的方法：

```
> contract.sayHello.call()
<!--
'hello world'
-->
```
在方法加入一个 constant 声明，表示调用
这个方法并不会改变区块链的状态。如此一来，透过 truffle-contract 来调用此方法时，会自动
选用 call 来呼叫，也不需要额外提供gas

下面我们在HelloWorld中加入一个新方法。<br>
在次运行上面命令<br>
在调用echo方法的时候，要传递一个字符串参数。

```
contract.echo("jusorlee")
```

如果以上内容对你有用，鼓励一下<br>
![打赏](https://raw.githubusercontent.com/jusorlee/blockchain/master/zan.jpg)