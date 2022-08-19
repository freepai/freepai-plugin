
//# init -n test --public-keys ProposalPlugin=0x3cfbc43bcfab0dd606c82dddd7570ff56ac0853ed87fa3846c43ad2c5c366d2f

//# faucet --addr ProposalPlugin --amount 10000000000000

//# run --signers ProposalPlugin
script {
    use ProposalPlugin::ProposalPlugin;

    fun main(sender: signer) {
        ProposalPlugin::initialize(sender);
    }
}
// check: EXECUTED