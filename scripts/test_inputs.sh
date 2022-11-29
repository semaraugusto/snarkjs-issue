#!/bin/bash
#
echo "generating valid witness"
pushd artifacts/circuits/test/test_js || exit
node generate_witness.js test.wasm ../input.json ../witness.wtns
cd ..
echo "generating proof"
npx snarkjs groth16 prove circuit_final.zkey witness.wtns proof.json public.json
echo "verifying proof"
npx snarkjs groth16 verify verification_key.json public.json proof.json


echo "generating invalid witness"
cd test_js || exit
node generate_witness.js test.wasm ../invalidInput.json ../invalidWitness.wtns
cd ..
echo "generating proof with invalid input"
npx snarkjs groth16 prove circuit_final.zkey invalidWitness.wtns invalidProof.json invalidPublic.json
echo "verifying proof"
npx snarkjs groth16 verify verification_key.json invalidPublic.json invalidProof.json

echo "generating invalid witness"
cd test_js || exit
node generate_witness.js test.wasm ../invalidInput2.json ../invalidWitness2.wtns
cd ..
echo "generating proof with invalid input"
npx snarkjs groth16 prove circuit_final.zkey invalidWitness2.wtns invalidProof2.json invalidPublic2.json
echo "verifying proof"
npx snarkjs groth16 verify verification_key.json invalidPublic2.json invalidProof2.json

popd || exit
