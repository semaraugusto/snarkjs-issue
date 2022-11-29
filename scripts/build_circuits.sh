#!/bin/bash

PTAU_PATH=./powersOfTau28_hez_final_12.ptau

if [ ! -f "$PTAU_PATH" ]; then
    curl -o $PTAU_PATH https://hermez.s3-eu-west-1.amazonaws.com/$PTAU_PATH
fi


compile () {
    local circuit="$1"
    mkdir -p build/$circuit
    mkdir -p artifacts/circuits/$circuit
    echo "circuits/$circuit.circom"
    ~/.cargo/bin/circom --r1cs --wasm --sym \
        -o artifacts/circuits/$circuit \
        circuits/$circuit.circom
    echo -e "Done!\n"
}


compile_phase2 () {
    local circuit="$1" pathToCircuitDir="$2"
    echo $circuit;
    mkdir -p $circuit;

    echo "Setting up Phase 2 ceremony for $circuit"
    echo "Outputting circuit_final.zkey and verifier.sol to $circuit"

    npx snarkjs groth16 setup "$pathToCircuitDir/$circuit.r1cs" $PTAU_PATH "$pathToCircuitDir/circuit_0000.zkey"
    echo "test" | npx snarkjs zkey contribute "$pathToCircuitDir/circuit_0000.zkey" "$pathToCircuitDir/circuit_0001.zkey" --name"1st Contributor name" -v
    npx snarkjs zkey verify "$pathToCircuitDir/$circuit.r1cs" $PTAU_PATH "$pathToCircuitDir/circuit_0001.zkey"
    npx snarkjs zkey beacon "$pathToCircuitDir/circuit_0001.zkey" "$pathToCircuitDir/circuit_final.zkey" 0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f 10 -n="Final Beacon phase2"
    npx snarkjs zkey verify "$pathToCircuitDir/$circuit.r1cs" $PTAU_PATH "$pathToCircuitDir/circuit_final.zkey"
    npx snarkjs zkey export verificationkey "$pathToCircuitDir/circuit_final.zkey" "$pathToCircuitDir/verification_key.json"  

    npx snarkjs zkey export solidityverifier "$pathToCircuitDir/circuit_final.zkey" $pathToCircuitDir/verifier.sol
    echo "Done!\n"
}

echo "Compiling test circuit"
compile test
compile_phase2 test ./artifacts/circuits/test
