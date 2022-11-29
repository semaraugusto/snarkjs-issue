pragma circom 2.0.0;

template AddVec(length) {
    signal input a[length];
    signal input b[length];
    signal output addVec[length];

    for (var i = 0; i < length; i++) {
        log(11111111);
        log(a[i]);
        log(b[i]);
        addVec[i] <== a[i] + b[i];
        log(addVec[i]);
    }

}
component main = AddVec(2);
