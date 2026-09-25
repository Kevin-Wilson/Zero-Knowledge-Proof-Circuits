# Zero Knowledge Proof Circuits

This project is my first step in creating a Zero Knowledge Proof Circuit (ZKP-Circuit). By using Noir, I'm looking to create a circuit that is useful for a real-world problem and deepen my understanding of how Zero Knowledge Proofs work. 

## Description

The circuit I created is a hypothetical ZKP-Circuit that could be used to verify eligbiility for a private loan. There are certain limitations in Noir with how arithmetic is handled so as a first look at Noir, I used a simplified formula that may not be accurate to real loan eligibility checks. 

Please find below a list of all private inputs: 
- Client net income 
- Client existing outgoing expenses 
- Requested loan amount 
- Loan term 
- Guarantor income 
- Guarantor outgoing expenses 

Please find below a list of all public inputs: 
- Current interest rate 
- Maximum debt to income ratio 
- Minimum income 
- Required reserve 

The prover (party who wishes to prove their loan eligiblity) can compile a witness of their values, and use it with my existing circit to generate a proof. This proof can then be verified by the verifier, to check if the prover is eligible for a loan. 

## Getting Started

### Dependencies/Tooling 

#### Noir 1.0.0-beta.22

https://noir-lang.org/docs/getting_started_manually

#### Barretenberg 5.0.0-nightly.20260522

https://github.com/AztecProtocol/aztec-packages/blob/next/barretenberg/bbup/README.md

### Installation

Beyond the above tools, no further installation is required. 

### Usage

```bash
cd zk_proof
```

#### 0. Compile the circuit 

```bash
nargo compile
```
NOTE: You don't need to do this as it's already been done. 

#### 1. Generate the witness 

- Overwrite the data in Prover.toml to use the desired public and private values. 
- Generate the witness from Prover.toml using the following command.

```bash
nargo execute
```

#### 2. Generate the proof

```bash
bb prove -b target/zk_proof.json -w target/zk_proof.gz -o target
```

#### 3. Verify the claim

```bash
bb verify -i target/public_inputs -p target/proof -k target/vk
```

## Authors

Kevin Wilson [@Kevin-Wilson](https://github.com/Kevin-Wilson)

## Licence

This project is licensed under the MIT Licence - see the [LICENSE](LICENSE) file for details.

Noir -> MIT/Apache-2.0 dual licence

Barretenberg -> Apache-2.0 licence 

