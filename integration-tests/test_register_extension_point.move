//# init -n test --public-keys FreePlugin=0x562712dad78be5126ac8afcb7e8d3d9385ba6dbc77dbc7fcd8cd4dc4bbf20286

//# faucet --addr FreePlugin --amount 10000000000000

//# run --signers FreePlugin
script {
    use FreePlugin::ExtensionPoint;

    fun main(sender: signer) {
        ExtensionPoint::initialize(sender);
    }
}
// check: EXECUTED

//# faucet --addr bob --amount 2000000000

//# run --signers bob
script {
    use FreePlugin::ExtensionPoint;

    fun main(sender: signer) {
        ExtensionPoint::register(sender, b"0x1::ExtensionPoint::IApp", b"ipfs:://xxxxxx", b"ipfs:://xxxxxx");
    }
}
// check: EXECUTED

//# view --address FreePlugin --resource 0x7dA9Cd8048A4620fda9e22977750C517::ExtensionPoint::Registry

//# faucet --addr alice --amount 2000000000

//# run --signers alice
script {
    use FreePlugin::ExtensionPoint;

    fun main(sender: signer) {
        ExtensionPoint::register(sender, b"0x1::ExtensionPoint::IApp", b"ipfs:://xxxxxx", b"ipfs:://xxxxxx");
    }
}
// check: EXECUTED

//# view --address FreePlugin --resource 0x7dA9Cd8048A4620fda9e22977750C517::ExtensionPoint::Registry
