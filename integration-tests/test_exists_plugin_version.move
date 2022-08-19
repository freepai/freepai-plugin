//# init -n test --public-keys FreePlugin=0x562712dad78be5126ac8afcb7e8d3d9385ba6dbc77dbc7fcd8cd4dc4bbf20286

//# faucet --addr FreePlugin --amount 10000000000000

//# run --signers FreePlugin
script {
    use FreePlugin::PluginMarketplaceScript;

    fun main(sender: signer) {
        PluginMarketplaceScript::initialize(sender);
    }
}
// check: EXECUTED

//# view --address FreePlugin --resource 0x7dA9Cd8048A4620fda9e22977750C517::PluginMarketplace::PluginRegistry

//# faucet --addr bob --amount 2000000000

//# run --signers bob
script {
    use FreePlugin::PluginMarketplaceScript;

    fun main(sender: signer) {
        PluginMarketplaceScript::register_plugin(sender, b"member_manager_plugin", b"ipfs:://xxxxxx");
    }
}
// check: EXECUTED

//# view --address FreePlugin --resource 0x7dA9Cd8048A4620fda9e22977750C517::PluginMarketplace::PluginRegistry

//# run --signers bob
script {
    use StarcoinFramework::Vector;
    use FreePlugin::PluginMarketplaceScript;

    fun main(sender: signer) {
        let vec = Vector::empty<vector<u8>>();
        Vector::push_back<vector<u8>>(&mut vec, b"member_manager_plugin");

        PluginMarketplaceScript::publish_plugin_version(
            sender, 
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

//# view --address FreePlugin --resource 0x7dA9Cd8048A4620fda9e22977750C517::PluginMarketplace::PluginRegistry

//# run --signers bob
script {
    use StarcoinFramework::Errors;
    use FreePlugin::PluginMarketplace;
    
    const ERR_PLUGIN_VERSION_NOT_EXISTS: u64 = 105;

    fun main(_sender: signer) {
        assert!(PluginMarketplace::exists_plugin_version(1, 1), Errors::invalid_state(ERR_PLUGIN_VERSION_NOT_EXISTS));
    }
}
// check: EXECUTED

//# run --signers bob
script {
    use StarcoinFramework::Errors;
    use FreePlugin::PluginMarketplace;
    
    const ERR_PLUGIN_VERSION_NOT_EXISTS: u64 = 105;

    fun main(_sender: signer) {
        assert!(PluginMarketplace::exists_plugin_version(1, 2), Errors::invalid_state(ERR_PLUGIN_VERSION_NOT_EXISTS));
    }
}
// check: EXECUTED


//# run --signers bob
script {
    use StarcoinFramework::Errors;
    use FreePlugin::PluginMarketplace;
    
    const ERR_PLUGIN_VERSION_NOT_EXISTS: u64 = 105;

    fun main(_sender: signer) {
        assert!(PluginMarketplace::exists_plugin_version(2, 0), Errors::invalid_state(ERR_PLUGIN_VERSION_NOT_EXISTS));
    }
}
// check: EXECUTED

//# run --signers bob
script {
    use StarcoinFramework::Errors;
    use FreePlugin::PluginMarketplace;
    
    const ERR_PLUGIN_VERSION_NOT_EXISTS: u64 = 105;

    fun main(_sender: signer) {
        assert!(PluginMarketplace::exists_plugin_version(2, 1), Errors::invalid_state(ERR_PLUGIN_VERSION_NOT_EXISTS));
    }
}
// check: EXECUTED