//# init -n test --public-keys FreePlugin=0x98826ab91a9a5d85dec536418090aa6342991bc8f947613721c8165e7102b132

//# faucet --addr FreePlugin --amount 10000000000000

//# run --signers FreePlugin
script {
    use FreePlugin::PluginMarketplace;

    fun main(sender: signer) {
        PluginMarketplace::initialize(sender);
    }
}
// check: EXECUTED

//# view --address FreePlugin --resource 0xf2aa2eae4ceaae88b308fc904975e4ae::PluginMarketplace::PluginRegistry

//# faucet --addr bob --amount 2000000000

//# run --signers bob
script {
    use FreePlugin::PluginMarketplace;

    fun main(sender: signer) {
        PluginMarketplace::register_plugin(&sender, b"member_manager_plugin", b"ipfs:://xxxxxx");
    }
}
// check: EXECUTED

//# view --address FreePlugin --resource 0xf2aa2eae4ceaae88b308fc904975e4ae::PluginMarketplace::PluginRegistry

//# run --signers bob
script {
    use StarcoinFramework::Vector;
    use FreePlugin::PluginMarketplace;

    fun main(sender: signer) {
        let vec = Vector::empty<vector<u8>>();
        Vector::push_back<vector<u8>>(&mut vec, b"member_manager_plugin");

        PluginMarketplace::publish_plugin_version(
            &sender, 
            1,
            b"v0.1.0", 
            *&vec, 
            *&vec, 
            *&vec, 
            *&vec, 
            b"0x1::PluginA", 
            b"ipfs:://xxxxxx"
        );
    }
}
// check: EXECUTED

//# view --address FreePlugin --resource 0xf2aa2eae4ceaae88b308fc904975e4ae::PluginMarketplace::PluginRegistry

//# run --signers bob
script {
    use StarcoinFramework::Vector;
    use FreePlugin::PluginMarketplace;

    fun main(sender: signer) {
        let vec = Vector::empty<vector<u8>>();
        Vector::push_back<vector<u8>>(&mut vec, b"member_manager_plugin");

        PluginMarketplace::publish_plugin_version(
            &sender, 
            2,
            b"v0.1.0", 
            *&vec, 
            *&vec, 
            *&vec, 
            *&vec, 
            b"0x1::PluginA", 
            b"ipfs:://xxxxxx"
        );
    }
}
// check: EXECUTED

