#!/bin/bash
#
rootDir=$(pwd);
artifactsDir=$rootDir/artifacts/circuits/test;

echo "generating valid witness $rootDir"
cd $artifactsDir/test_js || exit
echo "generating valid witness $rootDir"
node generate_witness.js test.wasm $rootDir/input.json $rootDir/witness.wtns
echo "generating valid witness $rootDir"
cd $rootDir || exit
echo "generating proof $rootDir"
npx snarkjs groth16 prove $artifactsDir/circuit_final.zkey $rootDir/witness.wtns $rootDir/proof.json $rootDir/public.json
echo "verifying proof"
npx snarkjs groth16 verify $artifactsDir/verification_key.json $rootDir/public.json $rootDir/proof.json


echo "generating invalid witness $rootDir"
cd $artifactsDir/test_js || exit
node generate_witness.js test.wasm $rootDir/invalidInput.json $rootDir/invalidWitness.wtns
echo "generating invalid witness $rootDir"
cd $rootDir || exit
echo "generating proof $rootDir"
npx snarkjs groth16 prove $artifactsDir/circuit_final.zkey $rootDir/invalidWitness.wtns $rootDir/invalidProof.json $rootDir/invalidPublic.json
echo "verifying proof"
npx snarkjs groth16 verify $artifactsDir/verification_key.json $rootDir/invalidPublic.json $rootDir/invalidProof.json

echo "generating invalid witness 2 $rootDir"
cd $artifactsDir/test_js || exit
node generate_witness.js test.wasm $rootDir/invalidInput2.json $rootDir/invalidWitness2.wtns
echo "generating invalid witness $rootDir"
cd $rootDir || exit
echo "generating proof $rootDir"
npx snarkjs groth16 prove $artifactsDir/circuit_final.zkey $rootDir/invalidWitness2.wtns $rootDir/invalidProof2.json $rootDir/invalidPublic2.json
echo "verifying proof"
npx snarkjs groth16 verify $artifactsDir/verification_key.json $rootDir/invalidPublic2.json $rootDir/invalidProof2.json
