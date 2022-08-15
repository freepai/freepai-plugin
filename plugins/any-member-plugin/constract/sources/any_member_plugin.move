module FreepaiDAO::AnyMemberPlugin {
    use StarcoinFramework::Signer;
    use StarcoinFramework::Errors;
    use StarcoinFramework::Vector;
    use FreePlugin::PluginMarketplace;

    const CONTRACT_ACCOUNT:address = @FreepaiDAO;

    const ERR_ALREADY_INITIALIZED: u64 = 100;
    const ERR_NOT_CONTRACT_OWNER: u64 = 101;
    const ERR_NOT_FOUND_PLUGIN: u64 = 102;
    const ERR_EXPECT_PLUGIN_NFT: u64 = 103;

    public(script) fun initialize(sender: signer) {
        assert!(Signer::address_of(&sender)==CONTRACT_ACCOUNT, Errors::requires_address(ERR_NOT_CONTRACT_OWNER));
        
        let plugin_id = PluginMarketplace::register_plugin(&sender, b"FreepaiDAO::AnyMemberPlugin", b"FreepaiDAO::AnyMemberPlugin");

        let vec = Vector::empty<vector<u8>>();
        Vector::push_back<vector<u8>>(&mut vec, b"member_manager_plugin");
        PluginMarketplace::publish_plugin_version(
            &sender, 
            plugin_id,
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