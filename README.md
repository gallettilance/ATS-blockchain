# ATS Blockchain

[![Build Status](https://travis-ci.org/galletti94/ATS-blockchain.svg?branch=v.0.2-beta)](https://travis-ci.org/galletti94/ATS-blockchain)
[![License](https://img.shields.io/badge/License-BSD%203--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)

A blockchain CLI in ATS

![example](gif/gif1.gif)

## About

Although this is currently just a toy blockchain, a number of fundamental functionalities - a refinement of which is underway - are currently supported. These include:

- mining a block
- appending a block to the blockchain
- creating a transaction
- creating a smart contract
- executing a smart contract

## The CLI

### Running the application

After installing [ATS](http://www.ats-lang.org/), simply run

```shell
git clone https://github.com/ashalkhakov/colorado.git  
make regress
```

Please follow the instructions in the CLI. If you wish to run a smart contract, please read below on how to create a smart contract.

### Smart Contracts

I implemented a lisp-like language for this blockchain to create what are called smart contracts. At a high level, these smart contracts are just code running on the blockchain so to speak. I provide the user with two ways of writing smart contracts. The first is by utilizing ATS, the other is by writing code directly in the lisp-like language. Both are currently very similar but the former allows for extending the lambda language to allow for more succinct verbosity, in addition to which one can utilize the typechecker and compiler of ATS for static syntactic debugging. It is hence recommended to utilize ATS to generate this lambda lisp-like language. Should you wish to write the smart contract directly in the CLI, you may do so after the "code" command. 

#### ATS -> lambda

Please take a look at the [examples](./lambda/example) folder along with the [helper_interp.dats](./lambda/helper_interp.dats) file for an example of writing code in ATS to generate lambda code and extend the lambda language. You can use ```make compile``` to compile all examples into the lisp-like lambda language.

#### lambda

The language is based on lambda calculus. Here are a few examples in this language:


**Integers**: 1 is represented as ```(TMint 1)```, 2 as ```(TMint 2)``` etc

**Bool**: True is ```(TMint 1)``` and False is ```(TMint 0)```

**String**: "hello, world!" is defined as ```(TMstr hello, world!)```

**Variable**: a variable x is declared as ```(TMvar x)```

**Tuples**: a tuple (t0, t1, t2) for example is defined as ```(TMtup t0 t1 t2)```

**Operations**: 2 + 3 + 4 is defined as ```(TMopr + (TMint 2) (TMint 3) (TMint 4))```

**Lambda Function**: <img src="https://latex.codecogs.com/svg.latex?\lambda&space;x.x&plus;x" title="\lambda x.x+x" /></a> can be defined as

```
(TMlam x (TMopr + (TMvar x) (TMvar x)))
```

**Function application**: applying the above lambda function to 1 can be done as such:

```
(TMapp (TMlam x (TMopr + (TMvar x) (TMvar x))) (TMint 1))
```

**Fixed Point (Recursive functions)**: the fibonacci function can be written as

  ```
  (TMfix f x
  	 (TMifnz (TMvar x)
	 	 (TMifnz (TMopr - (TMvar x) (TMint 1))
		 	 (TMopr +
			 (TMapp (TMvar f) (TMopr - (TMvar x) (TMint 1)))
			 (TMapp (TMvar f) (TMopr - (TMvar x) (TMint 2)))
			 )
		 (TMint 1))
	 (TMint 0))
  )
  ```

**Sequential operations**: 

```ats 
let val () = println!("hello, world!") in add(2, 3) end
``` 

can be encoded as

  ```
    (TMseq
      (TMopr println (TMstr hello, world!))
      (TMapp (TMapp (TMlam y (TMlam x (TMopr + (TMvar x) (TMvar y)))) (TMint 2)) (TMint 3))
    )	
  ```
  
As you can see, this language is not fit for encoding complex functions - although it is possible because of turing completeness. It is hence discouraged to write directly in this language. If you choose to write code directly you can either

- put your code in a .txt file - the relative path of which should be given to the "execute" command of the CLI.

- write your code after the "code" command of the CLI.

## TODO

- [ ] jsonify blockchain.txt
- [ ] refine using dependent types
- [ ] coinbase
- [ ] validate transactions
- [ ] make blockchain distributed
- [ ] enhance lambda lang to include transactions
- [ ] enhance lambda lang to be not lisp-like
- [ ] enhance lambda lang to be typed

------------

If you liked this and want to buy me coffee, feel free to donate BTC at 3QRRJu7ZHpegrBUMPmJw4pvcexH7qjvdyn or ETH at 0x13792d38f5E89bc0dE64Ccb9005A86B3574CB3f5. Thanks!
