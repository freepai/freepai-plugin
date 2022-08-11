//# init -n test --public-keys FreePlugin=0x98826ab91a9a5d85dec536418090aa6342991bc8f947613721c8165e7102b132

//# faucet --addr FreePlugin --amount 10000000000000

//# run --signers FreePlugin
script {
    use FreePlugin::ExtensionPointScripts;

    fun main(sender: signer) {
        ExtensionPointScripts::initialize(sender);
    }
}

//# view --address FreePlugin --resource 0xf2aa2eae4ceaae88b308fc904975e4ae::ExtensionPoint::ExtensionPointRegistry