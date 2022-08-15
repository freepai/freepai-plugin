//# init -n test --public-keys FreepaiDAO=0xad624e3bf00d324dbfa7236868a78fc8ec8346c082b05943696bbd82d4f2c26f

//# faucet --addr FreepaiDAO --amount 10000000000000

//# run --signers FreepaiDAO
script {
    use FreepaiDAO::FreepaiDAO;

    fun main(sender: signer) {
        FreepaiDAO::initialize(sender);
    }
}
// check: EXECUTED

//# view --address FreepaiDAO --resource 0x9960cd7C0A0C353336780F69400F00cf::FreepaiDAO::FreepaiDAO

//# faucet --addr bob --amount 2000000000

//# run --signers bob
script {
    use StarcoinFramework::Vector;
    use FreepaiDAO::FreepaiDAO;

    fun main(_sender: signer) {
        let vec = Vector::empty<u8>();
        Vector::push_back<u8>(&mut vec, 1);
        Vector::push_back<u8>(&mut vec, 2);

        FreepaiDAO::install_plugin(1, 1, vec)
    }
}
// check: EXECUTED

//# view --address FreepaiDAO --resource 0x9960cd7C0A0C353336780F69400F00cf::FreepaiDAO::FreepaiDAO

//# faucet --addr bob --amount 2000000000

//# run --signers bob
script {
    use StarcoinFramework::Vector;
    use FreepaiDAO::FreepaiDAO;

    fun main(_sender: signer) {
        let vec = Vector::empty<u8>();
        Vector::push_back<u8>(&mut vec, 3);
        Vector::push_back<u8>(&mut vec, 4);

        FreepaiDAO::install_plugin(2, 1, vec)
    }
}
// check: EXECUTED

//# view --address FreepaiDAO --resource 0x9960cd7C0A0C353336780F69400F00cf::FreepaiDAO::FreepaiDAO