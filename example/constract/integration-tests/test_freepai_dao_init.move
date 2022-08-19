//# init -n test --public-keys FreepaiDAO=0xad624e3bf00d324dbfa7236868a78fc8ec8346c082b05943696bbd82d4f2c26f

//# faucet --addr FreepaiDAO --amount 10000000000000

//# run --signers FreepaiDAO
script {
    use FreepaiDAO::FreepaiDAOScript;

    fun main(sender: signer) {
        FreepaiDAOScript::initialize(sender);
    }
}
// check: EXECUTED

//# view --address FreepaiDAO --resource 0x9960cd7C0A0C353336780F69400F00cf::FreepaiDAO::FreepaiDAO