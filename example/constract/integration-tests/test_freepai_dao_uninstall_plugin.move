//# init -n test --public-keys FreePlugin=0x562712dad78be5126ac8afcb7e8d3d9385ba6dbc77dbc7fcd8cd4dc4bbf20286 --public-keys FreepaiDAO=0xad624e3bf00d324dbfa7236868a78fc8ec8346c082b05943696bbd82d4f2c26f

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

//# run --signers FreepaiDAO
script {
    use StarcoinFramework::Vector;
    use FreepaiDAO::FreepaiDAOScript;

    fun main(sender: signer) {
        let vec = Vector::empty<u8>();
        Vector::push_back<u8>(&mut vec, 1);
        Vector::push_back<u8>(&mut vec, 2);

        FreepaiDAOScript::install_plugin(sender, 1, 1, vec)
    }
}
// check: EXECUTED

//# view --address FreepaiDAO --resource 0x9960cd7C0A0C353336780F69400F00cf::FreepaiDAO::FreepaiDAO

//# run --signers FreepaiDAO
script {
    use StarcoinFramework::Vector;
    use FreepaiDAO::FreepaiDAOScript;

    fun main(sender: signer) {
        FreepaiDAOScript::uninstall_plugin(sender, 2, 1)
    }
}
// check: EXECUTED

//# view --address FreepaiDAO --resource 0x9960cd7C0A0C353336780F69400F00cf::FreepaiDAO::FreepaiDAO

//# run --signers FreepaiDAO
script {
    use StarcoinFramework::Vector;
    use FreepaiDAO::FreepaiDAOScript;

    fun main(sender: signer) {
        FreepaiDAOScript::uninstall_plugin(sender, 1, 1)
    }
}
// check: EXECUTED

//# view --address FreepaiDAO --resource 0x9960cd7C0A0C353336780F69400F00cf::FreepaiDAO::FreepaiDAO